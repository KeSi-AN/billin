import 'package:material_ui/material_ui.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

enum PeriodPreset {
  today,
  yesterday,
  thisWeek,
  thisMonth,
  lastMonth,
  thisYear,
  custom,
}

/// A date range: [from] inclusive, [to] exclusive (both at midnight).
@immutable
class Period {
  const Period(this.preset, this.from, this.to);

  /// The range for [preset] as of [now]. Weeks start on Monday; the year
  /// is the Indian financial year (April to March).
  factory Period.of(PeriodPreset preset, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    DateTime day(int offset) =>
        DateTime(today.year, today.month, today.day + offset);
    return switch (preset) {
      PeriodPreset.today => Period(preset, today, day(1)),
      PeriodPreset.yesterday => Period(preset, day(-1), today),
      PeriodPreset.thisWeek => Period(preset, day(1 - today.weekday), day(1)),
      PeriodPreset.thisMonth => Period(
        preset,
        DateTime(now.year, now.month),
        day(1),
      ),
      PeriodPreset.lastMonth => Period(
        preset,
        DateTime(now.year, now.month - 1),
        DateTime(now.year, now.month),
      ),
      PeriodPreset.thisYear => Period(
        preset,
        DateTime(now.month >= 4 ? now.year : now.year - 1, 4),
        day(1),
      ),
      PeriodPreset.custom => Period(preset, today, day(1)),
    };
  }

  final PeriodPreset preset;
  final DateTime from;
  final DateTime to;

  @override
  bool operator ==(Object other) =>
      other is Period &&
      other.preset == preset &&
      other.from == from &&
      other.to == to;

  @override
  int get hashCode => Object.hash(preset, from, to);
}

String periodLabel(AppLocalizations l10n, PeriodPreset p) => switch (p) {
  PeriodPreset.today => l10n.periodToday,
  PeriodPreset.yesterday => l10n.periodYesterday,
  PeriodPreset.thisWeek => l10n.periodThisWeek,
  PeriodPreset.thisMonth => l10n.periodThisMonth,
  PeriodPreset.lastMonth => l10n.periodLastMonth,
  PeriodPreset.thisYear => l10n.periodThisYear,
  PeriodPreset.custom => l10n.periodCustom,
};

/// A row of chips: Today, Yesterday, This week… and a custom date range.
class PeriodPicker extends StatelessWidget {
  const PeriodPicker({required this.value, required this.onChanged, super.key});

  final Period value;
  final ValueChanged<Period> onChanged;

  Future<void> _custom(BuildContext context) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: value.from,
        end: value.to.subtract(const Duration(days: 1)),
      ),
    );
    if (range == null) return;
    onChanged(
      Period(
        PeriodPreset.custom,
        range.start,
        DateTime(range.end.year, range.end.month, range.end.day + 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final p in PeriodPreset.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                key: Key('period_${p.name}'),
                label: Text(periodLabel(l10n, p)),
                selected: value.preset == p,
                onSelected: (_) => p == PeriodPreset.custom
                    ? _custom(context)
                    : onChanged(Period.of(p, DateTime.now())),
              ),
            ),
        ],
      ),
    );
  }
}
