import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// "Due ₹500" (red), "Advance ₹20" (green) or "Settled".
class BalanceText extends StatelessWidget {
  const BalanceText(
    this.balance, {
    this.style,
    this.supplier = false,
    super.key,
  });

  final Money balance;
  final TextStyle? style;

  /// Supplier balances: positive means the shop owes them.
  final bool supplier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final base = style ?? Theme.of(context).textTheme.titleSmall;
    if (balance.isPositive) {
      return Text(
        supplier
            ? l10n.balanceYouOwe(balance.format())
            : l10n.balanceDue(balance.format()),
        style: base?.copyWith(color: scheme.error),
      );
    }
    if (balance.isNegative) {
      return Text(
        supplier
            ? l10n.balanceTheyOwe((-balance).format())
            : l10n.balanceAdvance((-balance).format()),
        style: base?.copyWith(color: scheme.primary),
      );
    }
    return Text(l10n.balanceSettled, style: base);
  }
}
