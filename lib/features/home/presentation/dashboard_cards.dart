import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/presentation/payment_mode_label.dart';
import 'package:shop_app/features/reports/domain/business_reports.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Today's sales with the split by payment mode (cash in the drawer vs UPI
/// vs on credit).
class TodayCard extends StatelessWidget {
  const TodayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return StreamBuilder<List<BillSummary>>(
      stream: context.read<BillRepository>().watchBetween(
        today,
        today.add(const Duration(days: 1)),
      ),
      builder: (context, snapshot) {
        final bills = (snapshot.data ?? const []).where((b) => !b.isCancelled);
        final total = bills.fold(Money.zero, (sum, b) => sum + b.grandTotal);
        // Paid now on a credit bill went into the drawer as cash.
        final byMode = {for (final m in PaymentMode.values) m: Money.zero};
        for (final b in bills) {
          if (b.paymentMode == PaymentMode.credit) {
            byMode[PaymentMode.credit] = byMode[PaymentMode.credit]! + b.due;
            byMode[PaymentMode.cash] =
                byMode[PaymentMode.cash]! + (b.grandTotal - b.due);
          } else {
            byMode[b.paymentMode] = byMode[b.paymentMode]! + b.grandTotal;
          }
        }
        return Card.outlined(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.push(AppRoutes.sales),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.homeToday, style: text.labelLarge),
                            Text(
                              total.format(),
                              key: const Key('todayTotal'),
                              style: text.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      Text(l10n.homeTodaySummary(bills.length)),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  if (bills.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 4,
                      children: [
                        for (final MapEntry(key: mode, value: amount)
                            in byMode.entries)
                          if (amount.isPositive)
                            Row(
                              key: Key('today_${mode.name}'),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(mode.icon, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${mode.label(l10n)} ${amount.format()}',
                                  style: text.bodySmall,
                                ),
                              ],
                            ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Best sellers of the last 7 days; hidden until something has sold.
class TopItemsCard extends StatefulWidget {
  const TopItemsCard({super.key, this.limit = 5});

  final int limit;

  @override
  State<TopItemsCard> createState() => _TopItemsCardState();
}

class _TopItemsCardState extends State<TopItemsCard> {
  StreamSubscription<void>? _changes;
  List<ItemSales> _top = const [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day - 6);
    final to = DateTime(now.year, now.month, now.day + 1);
    final bills = context.read<BillRepository>();
    // Any new or cancelled bill in the window refreshes the list.
    _changes = bills.watchBetween(from, to).listen((_) async {
      final list = itemSales(await bills.billsBetween(from, to));
      if (mounted) {
        setState(
          () => _top = list
              .where((s) => s.sales.isPositive)
              .take(widget.limit)
              .toList(),
        );
      }
    });
  }

  @override
  void dispose() {
    unawaited(_changes?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_top.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Card.outlined(
      key: const Key('topItemsCard'),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AppRoutes.report(ReportKind.itemWise)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.homeTopItems, style: text.labelLarge),
              const SizedBox(height: 4),
              for (final (i, s) in _top.indexed)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        child: Text('${i + 1}.', style: text.bodySmall),
                      ),
                      Expanded(
                        child: Text(
                          s.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${s.quantity.format()} ${s.unit}',
                        style: text.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 96,
                        child: Text(
                          s.sales.format(),
                          textAlign: TextAlign.right,
                          style: text.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
