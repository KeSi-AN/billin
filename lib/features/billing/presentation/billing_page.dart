import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/presentation/billing_cubit.dart';
import 'package:shop_app/features/billing/presentation/checkout_sheet.dart';
import 'package:shop_app/features/billing/presentation/line_sheets.dart';
import 'package:shop_app/features/inventory/domain/stock_alerts.dart';
import 'package:shop_app/features/items/domain/item.dart';
import 'package:shop_app/features/items/presentation/items_page.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => BillingCubit(
      items: context.read<ItemRepository>(),
      bills: context.read<BillRepository>(),
      settings: context.read<SettingsRepository>(),
      alerts: context.read<StockAlerts>(),
    ),
    child: const _BillingView(),
  );
}

class _BillingView extends StatefulWidget {
  const _BillingView();

  @override
  State<_BillingView> createState() => _BillingViewState();
}

class _BillingViewState extends State<_BillingView> {
  final _search = TextEditingController();
  final _searchFocus = FocusNode();

  BillingCubit get _cubit => context.read<BillingCubit>();

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  /// Keep the search box focused so a Bluetooth scanner's keystrokes always
  /// land in it, even right after a sheet or dialog closes.
  void _refocus() {
    if (mounted) _searchFocus.requestFocus();
  }

  Future<void> _submit(String value) async {
    final result = await _cubit.submitCode(value);
    if (!mounted) return;
    switch (result) {
      case CodeAdded():
        _search.clear();
      case CodeAmbiguous():
        break;
      case CodeNotFound(:final code):
        _search.clear();
        _offerCreate(code);
    }
    _refocus();
  }

  void _offerCreate(String code) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.billingNotFound(code)),
          // Don't linger over the checkout bar; scanning again replaces it.
          persist: false,
          action: SnackBarAction(
            label: l10n.billingCreateItem,
            onPressed: () => _createItem(code),
          ),
        ),
      );
  }

  Future<void> _createItem(String barcode) async {
    final item = await context.push<Item>(
      AppRoutes.newItemWithBarcode(barcode),
    );
    if (item != null) _cubit.addItem(item);
    _refocus();
  }

  Future<void> _cameraScan() async {
    final code = await context.push<String>(AppRoutes.scan);
    if (code != null) await _submit(code);
    _refocus();
  }

  Future<void> _quickItem() async {
    final quick = await showQuickItemSheet(context);
    if (quick != null) {
      _cubit.addQuickItem(
        name: quick.name,
        price: quick.price,
        quantity: quick.quantity,
        taxRate: quick.taxRate,
      );
    }
    _refocus();
  }

  Future<void> _editLine(int index, DraftLine line) async {
    final result = await showEditLineSheet(
      context,
      line,
      item: _cubit.state.itemFor(line),
    );
    if (result != null) {
      final updated = result.line;
      if (updated == null) {
        _cubit.removeLine(index);
      } else {
        _cubit.updateLine(index, updated);
      }
    }
    _refocus();
  }

  Future<void> _checkout() async {
    final bill = await showCheckoutSheet(context);
    if (bill != null && mounted) {
      context.pushReplacement(AppRoutes.bill(bill.id, justSaved: true));
    } else {
      _refocus();
    }
  }

  Future<bool> _confirmDiscard() {
    if (_cubit.state.isEmpty) return Future.value(true);
    final l10n = AppLocalizations.of(context);
    return confirm(
      context,
      title: l10n.billingDiscardTitle,
      confirmLabel: l10n.billingDiscard,
      destructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard() && context.mounted) context.pop();
      },
      // Any change to the cart makes an old "not found" message stale.
      child: BlocListener<BillingCubit, BillingState>(
        listenWhen: (a, b) => a.lines != b.lines,
        listener: (context, _) =>
            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.billingTitle),
            actions: [
              IconButton(
                key: const Key('cameraScanButton'),
                tooltip: l10n.scanBarcode,
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: _cameraScan,
              ),
              BlocBuilder<BillingCubit, BillingState>(
                buildWhen: (a, b) => a.isEmpty != b.isEmpty,
                builder: (context, state) => IconButton(
                  tooltip: l10n.billingClear,
                  icon: const Icon(Icons.delete_sweep_outlined),
                  onPressed: state.isEmpty
                      ? null
                      : () async {
                          final ok = await confirm(
                            context,
                            title: l10n.billingClearConfirm,
                            confirmLabel: l10n.billingClear,
                            destructive: true,
                          );
                          if (ok) _cubit.clear();
                          _refocus();
                        },
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  key: const Key('billingSearchField'),
                  controller: _search,
                  focusNode: _searchFocus,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: l10n.billingSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: ListenableBuilder(
                      listenable: _search,
                      builder: (context, _) => _search.text.isEmpty
                          ? const SizedBox.shrink()
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _search.clear();
                                unawaited(_cubit.queryChanged(''));
                                _refocus();
                              },
                            ),
                    ),
                  ),
                  onChanged: _cubit.queryChanged,
                  onSubmitted: _submit,
                ),
              ),
              Expanded(
                child: BlocBuilder<BillingCubit, BillingState>(
                  builder: (context, state) {
                    if (state.suggestions.isNotEmpty) {
                      return ListView(
                        key: const Key('suggestions'),
                        children: [
                          for (final item in state.suggestions)
                            ItemTile(
                              item: item,
                              onTap: () {
                                _cubit.addItem(item);
                                _search.clear();
                                _refocus();
                              },
                            ),
                        ],
                      );
                    }
                    if (state.isEmpty) return const _EmptyCart();
                    return ListView.separated(
                      key: const Key('cart'),
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: state.lines.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) => _CartLine(
                        line: state.lines[i],
                        total: state.totals.lines[i].total,
                        shortage: state.shortage(state.lines[i]),
                        stockUnit: state.itemFor(state.lines[i])?.unit,
                        highlighted: state.lastChanged == i,
                        onTap: () => _editLine(i, state.lines[i]),
                        onStep: ({required up}) {
                          _cubit.step(i, up: up);
                          _refocus();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Bottom bar slot: snackbars ("not found") appear above it.
          bottomNavigationBar: _BottomBar(
            onQuickItem: _quickItem,
            onCheckout: _checkout,
          ),
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 56,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.billingEmpty,
              textAlign: TextAlign.center,
              style: text.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.billingScannerTip,
              textAlign: TextAlign.center,
              style: text.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartLine extends StatelessWidget {
  const _CartLine({
    required this.line,
    required this.total,
    required this.highlighted,
    required this.onTap,
    required this.onStep,
    this.shortage,
    this.stockUnit,
  });

  final DraftLine line;
  final Money total;

  /// Set when the item has less stock than this bill needs.
  final Quantity? shortage;
  final String? stockUnit;
  final bool highlighted;
  final VoidCallback onTap;
  final void Function({required bool up}) onStep;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Material(
      color: highlighted
          ? scheme.secondaryContainer.withValues(alpha: 0.4)
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(line.name, style: text.titleSmall),
                    Text(
                      l10n.billQtyAtPrice(
                        line.quantity.format(),
                        line.unit,
                        line.unitPrice.format(),
                      ),
                      style: text.bodySmall,
                    ),
                    if (!line.discount.isZero)
                      Text(
                        l10n.lineDiscountTag(line.discount.format()),
                        style: text.bodySmall?.copyWith(color: scheme.tertiary),
                      ),
                    if (shortage != null)
                      Text(
                        l10n.onlyLeft(
                          shortage!.format(),
                          stockUnit ?? line.unit,
                        ),
                        key: const Key('shortageWarning'),
                        style: text.bodySmall?.copyWith(color: scheme.error),
                      ),
                  ],
                ),
              ),
              Text(total.format(), style: text.titleSmall),
              IconButton(
                key: const Key('qtyMinus'),
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => onStep(up: false),
              ),
              IconButton(
                key: const Key('qtyPlus'),
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => onStep(up: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onQuickItem, required this.onCheckout});

  final VoidCallback onQuickItem;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      elevation: 3,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: BlocBuilder<BillingCubit, BillingState>(
            builder: (context, state) => Row(
              children: [
                OutlinedButton.icon(
                  key: const Key('quickItemButton'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                  ),
                  onPressed: onQuickItem,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.billingQuickItem),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    key: const Key('checkoutButton'),
                    onPressed: state.isEmpty ? null : onCheckout,
                    child: Text(
                      l10n.billingCheckout(state.totals.grandTotal.format()),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
