import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/presentation/payment_mode_label.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Bills for one day, with the day's totals.
class SalesPage extends StatefulWidget {
  const SalesPage({this.clock = DateTime.now, super.key});

  final DateTime Function() clock;

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  late DateTime _day = _dateOnly(widget.clock());

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  bool get _isToday => _day == _dateOnly(widget.clock());

  void _shift(int days) =>
      setState(() => _day = DateTime(_day.year, _day.month, _day.day + days));

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(2020),
      lastDate: _dateOnly(widget.clock()),
    );
    if (picked != null) setState(() => _day = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final next = DateTime(_day.year, _day.month, _day.day + 1);
    final title = _isToday
        ? l10n.salesToday
        : DateFormat('EEE, d MMM y', appLocale).format(_day);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.salesTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: l10n.salesPreviousDay,
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _shift(-1),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: _pickDay,
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    label: Text(title, style: text.titleMedium),
                  ),
                ),
                IconButton(
                  tooltip: l10n.salesNextDay,
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _isToday ? null : () => _shift(1),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<BillSummary>>(
              key: ValueKey(_day),
              stream: context.read<BillRepository>().watchBetween(_day, next),
              builder: (context, snapshot) {
                final bills = snapshot.data;
                if (bills == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final completed = bills.where((b) => !b.isCancelled);
                final total = completed.fold(
                  Money.zero,
                  (sum, b) => sum + b.grandTotal,
                );
                final byMode = <PaymentMode, Money>{};
                for (final b in completed) {
                  byMode[b.paymentMode] =
                      (byMode[b.paymentMode] ?? Money.zero) + b.grandTotal;
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.salesTotal, style: text.labelLarge),
                            Text(
                              total.format(),
                              key: const Key('salesTotal'),
                              style: text.headlineMedium,
                            ),
                            Text(l10n.salesBills(completed.length)),
                            if (byMode.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  for (final e in byMode.entries)
                                    Chip(
                                      avatar: Icon(e.key.icon, size: 18),
                                      label: Text(
                                        '${e.key.label(l10n)} ${e.value.format()}',
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (bills.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(child: Text(l10n.salesEmpty)),
                      ),
                    for (final b in bills) _BillTile(bill: b),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BillTile extends StatelessWidget {
  const _BillTile({required this.bill});

  final BillSummary bill;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final time = DateFormat(
      'h:mm a',
      appLocale,
    ).format(bill.billedAt).toLowerCase();
    final amountStyle = text.titleMedium?.copyWith(
      decoration: bill.isCancelled ? TextDecoration.lineThrough : null,
      color: bill.isCancelled ? scheme.outline : null,
    );
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => context.push(AppRoutes.bill(bill.id)),
      leading: CircleAvatar(child: Icon(bill.paymentMode.icon, size: 20)),
      title: Text(bill.invoiceNo),
      subtitle: Text(
        [
          time,
          l10n.billingItemsCount(bill.lineCount),
          ?bill.customerName,
          if (bill.isCancelled) l10n.billCancelled,
        ].join(' · '),
      ),
      trailing: Text(bill.grandTotal.format(), style: amountStyle),
    );
  }
}
