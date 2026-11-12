import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Result of the edit-line sheet: an updated line, or `null` to remove it.
typedef LineEditResult = ({DraftLine? line});

/// Change quantity, price or discount of a cart line.
Future<LineEditResult?> showEditLineSheet(
  BuildContext context,
  DraftLine line,
) => showModalBottomSheet<LineEditResult>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _EditLineSheet(line: line),
);

class _EditLineSheet extends StatefulWidget {
  const _EditLineSheet({required this.line});

  final DraftLine line;

  @override
  State<_EditLineSheet> createState() => _EditLineSheetState();
}

class _EditLineSheetState extends State<_EditLineSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _qty = TextEditingController(text: widget.line.quantity.format());
  late final _price = TextEditingController(
    text: widget.line.unitPrice.toInput(),
  );
  late final _discount = TextEditingController(
    text: widget.line.discount.isZero ? '' : widget.line.discount.toInput(),
  );

  @override
  void dispose() {
    _qty.dispose();
    _price.dispose();
    _discount.dispose();
    super.dispose();
  }

  void _apply() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop<LineEditResult>(context, (
      line: widget.line.copyWith(
        quantity: Quantity.tryParse(_qty.text),
        unitPrice: Money.tryParse(_price.text),
        discount: Money.tryParse(_discount.text) ?? Money.zero,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SheetBody(
      title: widget.line.name,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: QuantityField(
                    key: const Key('lineQtyField'),
                    controller: _qty,
                    label: '${l10n.fieldQuantity} (${widget.line.unit})',
                    autofocus: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MoneyField(
                    key: const Key('linePriceField'),
                    controller: _price,
                    label: l10n.fieldUnitPrice(widget.line.unit),
                    isRequired: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            MoneyField(
              key: const Key('lineDiscountField'),
              controller: _discount,
              label: l10n.fieldDiscount,
              helperText: l10n.optional,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () =>
                      Navigator.pop<LineEditResult>(context, (line: null)),
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.lineRemove),
                ),
                const Spacer(),
                FilledButton(
                  key: const Key('lineApplyButton'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(120, 48),
                  ),
                  onPressed: _apply,
                  child: Text(l10n.done),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A one-off item that isn't saved to the item list.
typedef QuickItem = ({
  String name,
  Money price,
  Quantity quantity,
  TaxRate taxRate,
});

Future<QuickItem?> showQuickItemSheet(BuildContext context) =>
    showModalBottomSheet<QuickItem>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _QuickItemSheet(),
    );

class _QuickItemSheet extends StatefulWidget {
  const _QuickItemSheet();

  @override
  State<_QuickItemSheet> createState() => _QuickItemSheetState();
}

class _QuickItemSheetState extends State<_QuickItemSheet> {
  final _formKey = GlobalKey<FormState>();
  final _price = TextEditingController();
  final _qty = TextEditingController(text: '1');
  final _name = TextEditingController();
  TaxRate _taxRate = TaxRate.zero;

  @override
  void dispose() {
    _price.dispose();
    _qty.dispose();
    _name.dispose();
    super.dispose();
  }

  void _add() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context);
    final name = _name.text.trim();
    Navigator.pop<QuickItem>(context, (
      name: name.isEmpty ? l10n.billingQuickItemDefaultName : name,
      price: Money.tryParse(_price.text)!,
      quantity: Quantity.tryParse(_qty.text)!,
      taxRate: _taxRate,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SheetBody(
      title: l10n.billingQuickItem,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: MoneyField(
                    key: const Key('quickPriceField'),
                    controller: _price,
                    label: l10n.fieldSalePrice,
                    isRequired: true,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: QuantityField(
                    controller: _qty,
                    label: l10n.fieldQuantity,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l10n.billingQuickItemName),
            ),
            const SizedBox(height: 16),
            TaxRateField(
              value: _taxRate,
              onChanged: (r) => setState(() => _taxRate = r),
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('quickAddButton'),
              onPressed: _add,
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom-sheet frame that stays above the keyboard.
class _SheetBody extends StatelessWidget {
  const _SheetBody({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      16,
      0,
      16,
      16 + MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ),
  );
}
