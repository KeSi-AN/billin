import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/bill_calculator.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';

class BillingState extends Equatable {
  BillingState({
    this.lines = const [],
    this.suggestions = const [],
    this.roundToRupee = true,
    this.lastChanged,
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

  bool get isEmpty => lines.isEmpty;

  BillingState copyWith({
    List<DraftLine>? lines,
    List<Item>? suggestions,
    bool? roundToRupee,
    int? Function()? lastChanged,
  }) => BillingState(
    lines: lines ?? this.lines,
    suggestions: suggestions ?? this.suggestions,
    roundToRupee: roundToRupee ?? this.roundToRupee,
    lastChanged: lastChanged != null ? lastChanged() : this.lastChanged,
  );

  @override
  List<Object?> get props => [lines, suggestions, roundToRupee, lastChanged];
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
  }) : super(BillingState()) {
    unawaited(_loadSettings());
  }

  final ItemRepository _items;
  final BillRepository _bills;
  final SettingsRepository _settings;

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
    String? customerName,
    String? customerPhone,
  }) async {
    final bill = await _bills.create(
      BillDraft(
        lines: state.lines,
        billDiscount: billDiscount,
        paymentMode: paymentMode,
        customerName: customerName,
        customerPhone: customerPhone,
      ),
    );
    clear();
    return bill;
  }
}
