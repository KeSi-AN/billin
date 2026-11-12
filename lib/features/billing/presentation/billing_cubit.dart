import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/money/rounding.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/inventory/domain/stock_alerts.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';

class BillingState extends Equatable {
  BillingState({
    this.lines = const [],
    this.suggestions = const [],
    this.roundToRupee = true,
    this.lastChanged,
    this.items = const {},
  }) : totals = BillCalculator.calculate([
         for (final l in lines) l.input,
       ], roundToRupee: roundToRupee);

  final List<DraftLine> lines;

  /// Items matching what's typed in the search box.
  final List<Item> suggestions;
  final bool roundToRupee;

  /// Index of the line just added or changed, to scroll to and highlight.
  final int? lastChanged;

  /// Totals before any bill discount (that's chosen at checkout).
  final BillTotals totals;

  /// The saved items in the cart, by id: their stock and second unit.
  final Map<int, Item> items;

  bool get isEmpty => lines.isEmpty;

  Item? itemFor(DraftLine line) =>
      line.itemId == null ? null : items[line.itemId];

  /// Stock left for [line]'s item if this bill goes through, when that is
  /// less than the bill needs (counts every line of the same item).
  Quantity? shortage(DraftLine line) {
    final item = itemFor(line);
    if (item == null || !item.trackStock) return null;
    final wanted = lines
        .where((l) => l.itemId == item.id)
        .fold(Quantity.zero, (sum, l) => sum + l.baseQuantity);
    return wanted > item.stock ? item.stock : null;
  }

  BillingState copyWith({
    List<DraftLine>? lines,
    List<Item>? suggestions,
    bool? roundToRupee,
    int? Function()? lastChanged,
    Map<int, Item>? items,
  }) => BillingState(
    lines: lines ?? this.lines,
    suggestions: suggestions ?? this.suggestions,
    roundToRupee: roundToRupee ?? this.roundToRupee,
    lastChanged: lastChanged != null ? lastChanged() : this.lastChanged,
    items: items ?? this.items,
  );

  @override
  List<Object?> get props => [
    lines,
    suggestions,
    roundToRupee,
    lastChanged,
    items,
  ];
}

/// What happened when a scanned or typed code was submitted.
sealed class CodeResult {
  const CodeResult();
}

final class CodeAdded extends CodeResult {
  const CodeAdded(this.item);

  final Item item;
}

/// Several items match a typed name: the user picks from the suggestions.
final class CodeAmbiguous extends CodeResult {
  const CodeAmbiguous();
}

final class CodeNotFound extends CodeResult {
  const CodeNotFound(this.code);

  final String code;
}

/// The bill being built at the counter.
class BillingCubit extends Cubit<BillingState> {
  BillingCubit({
    required this._items,
    required this._bills,
    required this._settings,
    this._alerts,
  }) : super(BillingState()) {
    unawaited(_loadSettings());
  }

  final ItemRepository _items;
  final BillRepository _bills;
  final SettingsRepository _settings;
  final StockAlerts? _alerts;

  Future<void> _loadSettings() async {
    final s = await _settings.load();
    if (!isClosed) emit(state.copyWith(roundToRupee: s.roundToRupee));
  }

  Future<void> queryChanged(String query) async {
    final results = query.trim().isEmpty
        ? const <Item>[]
        : await _items.search(query, limit: 8);
    if (!isClosed) emit(state.copyWith(suggestions: results));
  }

  /// A Bluetooth scanner "types" the code and presses Enter, which lands
  /// here. Also handles a name typed by hand and confirmed with Enter.
  Future<CodeResult> submitCode(String raw) async {
    final code = raw.trim();
    if (code.isEmpty) return const CodeAmbiguous();
    var item = await _items.byBarcode(code);
    if (item == null) {
      final matches = await _items.search(code, limit: 8);
      if (matches.length == 1) item = matches.single;
      if (matches.length > 1) {
        emit(state.copyWith(suggestions: matches));
        return const CodeAmbiguous();
      }
    }
    if (item == null) return CodeNotFound(code);
    addItem(item);
    return CodeAdded(item);
  }

  /// Adds one unit. Scanning the same item again bumps its quantity.
  void addItem(Item item) {
    final items = {...state.items, item.id!: item};
    final lines = [...state.lines];
    final existing = lines.indexWhere(
      (l) =>
          l.itemId != null &&
          l.itemId == item.id &&
          l.unitPrice == item.salePrice &&
          l.discount.isZero,
    );
    if (existing >= 0) {
      lines[existing] = lines[existing].copyWith(
        quantity: lines[existing].quantity + Quantity.one,
      );
      emit(
        state.copyWith(
          lines: lines,
          suggestions: [],
          lastChanged: () => existing,
          items: items,
        ),
      );
      return;
    }
    lines.add(
      DraftLine(
        itemId: item.id,
        name: item.name,
        unit: item.unit,
        hsn: item.hsn,
        unitPrice: item.salePrice,
        taxRate: item.taxRate,
        priceIncludesTax: item.priceIncludesTax,
      ),
    );
    emit(
      state.copyWith(
        lines: lines,
        suggestions: [],
        lastChanged: () => lines.length - 1,
        items: items,
      ),
    );
  }

  /// Switches a line between the item's base unit and its second unit
  /// (e.g. pcs ↔ box), with the matching price.
  void switchUnit(int index, {required bool alt}) {
    final line = state.lines[index];
    final item = state.itemFor(line);
    if (item == null || !item.hasAltUnit) return;
    updateLine(
      index,
      alt
          ? line.copyWith(
              unit: item.altUnit,
              unitFactor: item.altUnitFactor,
              unitPrice:
                  item.altUnitPrice ??
                  Money.paise(
                    divRound(
                      item.salePrice.paise * item.altUnitFactor!.milli,
                      1000,
                    ),
                  ),
            )
          : line.copyWith(
              unit: item.unit,
              unitFactor: Quantity.one,
              unitPrice: item.salePrice,
            ),
    );
  }

  /// A one-off item that isn't in the item list ("loose" sale).
  void addQuickItem({
    required String name,
    required Money price,
    Quantity quantity = Quantity.one,
    TaxRate taxRate = TaxRate.zero,
  }) {
    final lines = [
      ...state.lines,
      DraftLine(
        name: name,
        unitPrice: price,
        quantity: quantity,
        taxRate: taxRate,
      ),
    ];
    emit(state.copyWith(lines: lines, lastChanged: () => lines.length - 1));
  }

  /// +1 / −1 from the stepper. Going below one removes the line.
  void step(int index, {required bool up}) {
    final line = state.lines[index];
    final next = up
        ? line.quantity + Quantity.one
        : line.quantity - Quantity.one;
    if (!next.isPositive) {
      removeLine(index);
      return;
    }
    updateLine(index, line.copyWith(quantity: next));
  }

  void updateLine(int index, DraftLine line) {
    final lines = [...state.lines]..[index] = line;
    emit(state.copyWith(lines: lines, lastChanged: () => index));
  }

  void removeLine(int index) {
    final lines = [...state.lines]..removeAt(index);
    emit(state.copyWith(lines: lines, lastChanged: () => null));
  }

  void clear() =>
      emit(state.copyWith(lines: [], suggestions: [], lastChanged: () => null));

  /// Totals including a bill discount, for the checkout preview.
  BillTotals preview(Money billDiscount) => BillCalculator.calculate(
    [for (final l in state.lines) l.input],
    billDiscount: billDiscount,
    roundToRupee: state.roundToRupee,
  );

  Future<Bill> save({
    required PaymentMode paymentMode,
    Money billDiscount = Money.zero,
    Party? customer,
    Money paidNow = Money.zero,
  }) async {
    // Stock before the sale, to spot items that cross their low level.
    final before = <Item>[];
    for (final id in {for (final l in state.lines) ?l.itemId}) {
      final item = await _items.byId(id);
      if (item != null && item.trackStock && item.lowStock != null) {
        before.add(item);
      }
    }
    final sold = <int, Quantity>{};
    for (final l in state.lines) {
      if (l.itemId == null) continue;
      sold[l.itemId!] = (sold[l.itemId!] ?? Quantity.zero) + l.baseQuantity;
    }

    final bill = await _bills.create(
      BillDraft(
        lines: state.lines,
        billDiscount: billDiscount,
        paymentMode: paymentMode,
        customerName: customer?.name,
        customerPhone: customer?.phone,
        partyId: customer?.id,
        paidNow: paidNow,
      ),
    );
    clear();

    final crossed = [
      for (final item in before)
        if (item.stock > item.lowStock! &&
            !(item.stock - sold[item.id]! > item.lowStock!))
          item.copyWith(stock: item.stock - sold[item.id]!),
    ];
    if (crossed.isNotEmpty) unawaited(_alerts?.lowStock(crossed));
    return bill;
  }
}
