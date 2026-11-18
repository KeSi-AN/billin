import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/money/percent.dart';
import 'package:shop_app/core/money/quantity.dart';
import 'package:shop_app/features/billing/domain/tax_rate.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Rupee amount input. Validates with [Money.tryParse].
class MoneyField extends StatelessWidget {
  const MoneyField({
    required this.controller,
    required this.label,
    this.isRequired = false,
    this.extraValidator,
    this.helperText,
    this.autofocus = false,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool isRequired;
  final String? Function(Money value)? extraValidator;
  final String? helperText;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      textInputAction: textInputAction,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
      decoration: InputDecoration(
        labelText: label,
        prefixText: '₹ ',
        helperText: helperText,
      ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: (text) {
        final v = text?.trim() ?? '';
        if (v.isEmpty) return isRequired ? l10n.errAmountRequired : null;
        final money = Money.tryParse(v);
        if (money == null) return l10n.errAmountInvalid;
        return extraValidator?.call(money);
      },
    );
  }
}

/// Quantity input: whole numbers or up to 3 decimals (0.5 kg).
class QuantityField extends StatelessWidget {
  const QuantityField({
    required this.controller,
    required this.label,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
      decoration: InputDecoration(labelText: label),
      validator: (text) {
        final q = Quantity.tryParse(text ?? '');
        return (q == null || !q.isPositive) ? l10n.errQuantityInvalid : null;
      },
    );
  }
}

/// A discount typed as an amount (₹) or a percentage (%), switched by the
/// toggle at the end of the field. [max] caps an amount (e.g. the line
/// value); a percentage is always 0–100.
class DiscountField extends StatelessWidget {
  const DiscountField({
    required this.controller,
    required this.percent,
    required this.onPercentChanged,
    required this.label,
    this.max,
    this.helperText,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final bool percent;
  final ValueChanged<bool> onPercentChanged;
  final String label;
  final Money? max;
  final String? helperText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixText: percent ? null : '₹ ',
        suffixIcon: Padding(
          padding: const EdgeInsets.all(6),
          child: SegmentedButton<bool>(
            key: const Key('discountModeToggle'),
            showSelectedIcon: false,
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            segments: const [
              ButtonSegment(value: false, label: Text('₹')),
              ButtonSegment(value: true, label: Text('%')),
            ],
            selected: {percent},
            onSelectionChanged: (v) => onPercentChanged(v.first),
          ),
        ),
      ),
      onChanged: onChanged,
      validator: (text) {
        final v = text?.trim() ?? '';
        if (v.isEmpty) return null;
        if (percent) {
          return parsePercentBp(v) == null ? l10n.errPercentInvalid : null;
        }
        final money = Money.tryParse(v);
        if (money == null) return l10n.errAmountInvalid;
        if (max != null && money > max!) return l10n.errDiscountTooBig;
        return null;
      },
    );
  }
}

/// GST rate picker.
class TaxRateField extends StatelessWidget {
  const TaxRateField({required this.value, required this.onChanged, super.key});

  final TaxRate value;
  final ValueChanged<TaxRate> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final choices = [
      ...TaxRate.choices,
      if (!TaxRate.choices.contains(value)) value,
    ];
    return DropdownButtonFormField<TaxRate>(
      initialValue: value,
      decoration: InputDecoration(labelText: l10n.fieldGstRate),
      items: [
        for (final r in choices)
          DropdownMenuItem(value: r, child: Text(r.label)),
      ],
      onChanged: (r) {
        if (r != null) onChanged(r);
      },
    );
  }
}

/// Simple yes/no dialog. Returns `true` when confirmed.
Future<bool> confirm(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  String? body,
  bool destructive = false,
}) async {
  final l10n = AppLocalizations.of(context);
  final scheme = Theme.of(context).colorScheme;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: body == null ? null : Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                  minimumSize: const Size(64, 40),
                )
              : FilledButton.styleFrom(minimumSize: const Size(64, 40)),
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
