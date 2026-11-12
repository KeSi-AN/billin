import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/format/dates.dart';

/// First day of [d]'s month.
DateTime monthStart(DateTime d) => DateTime(d.year, d.month);

/// First day of the following month.
DateTime nextMonth(DateTime m) => DateTime(m.year, m.month + 1);

/// `‹  November 2026  ›`, never past the current month.
class MonthSwitcher extends StatelessWidget {
  const MonthSwitcher({
    required this.month,
    required this.onChanged,
    this.previousLabel = '',
    this.nextLabel = '',
    super.key,
  });

  final DateTime month;
  final ValueChanged<DateTime> onChanged;
  final String previousLabel;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    final current = monthStart(DateTime.now());
    final atCurrent = !month.isBefore(current);
    return Row(
      children: [
        IconButton(
          tooltip: previousLabel,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => onChanged(DateTime(month.year, month.month - 1)),
        ),
        Expanded(
          child: Text(
            DateFormat('MMMM y', appLocale).format(month),
            key: const Key('monthLabel'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          tooltip: nextLabel,
          icon: const Icon(Icons.chevron_right),
          onPressed: atCurrent ? null : () => onChanged(nextMonth(month)),
        ),
      ],
    );
  }
}
