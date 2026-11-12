import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/core/widgets/month_switcher.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/presentation/payment_mode_label.dart';
import 'package:shop_app/features/expenses/domain/expense.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Expenses by month.
class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  DateTime _month = monthStart(DateTime.now());

  Future<void> _delete(Expense e) async {
    final l10n = AppLocalizations.of(context);
    final ok = await confirm(
      context,
      title: l10n.expenseDeleteConfirm(e.amount.format()),
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!ok || !mounted) return;
    await context.read<ExpenseRepository>().delete(e.id!);
    if (mounted) showSnack(context, l10n.expenseDeleted);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.expensesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('addExpenseButton'),
        onPressed: () => showAddExpenseSheet(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.expenseAdd),
      ),
      body: Column(
        children: [
          MonthSwitcher(
            month: _month,
            onChanged: (m) => setState(() => _month = m),
            previousLabel: l10n.reportsPreviousMonth,
            nextLabel: l10n.reportsNextMonth,
          ),
          Expanded(
            child: StreamBuilder<List<Expense>>(
              key: ValueKey(_month),
              stream: context.read<ExpenseRepository>().watchBetween(
                _month,
                nextMonth(_month),
              ),
              builder: (context, snapshot) {
                final list = snapshot.data;
                if (list == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final total = list.fold(Money.zero, (s, e) => s + e.amount);
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
                  children: [
                    Card(
                      child: ListTile(
                        title: Text(
                          l10n.expensesMonthTotal,
                          style: text.labelLarge,
                        ),
                        trailing: Text(
                          total.format(),
                          key: const Key('expensesTotal'),
                          style: text.titleLarge,
                        ),
                      ),
                    ),
                    if (list.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Center(child: Text(l10n.expensesEmpty)),
                      ),
                    for (final e in list)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        onLongPress: () => _delete(e),
                        title: Text(e.category),
                        subtitle: Text(
                          [
                            formatDate(e.spentAt),
                            e.paymentMode.label(l10n),
                            ?e.note,
                          ].join(' · '),
                        ),
                        trailing: Text(
                          e.amount.format(),
                          style: text.titleSmall,
                        ),
                      ),
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

Future<void> showAddExpenseSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => RepositoryProvider.value(
        value: context.read<ExpenseRepository>(),
        child: const _ExpenseSheet(),
      ),
    );

class _ExpenseSheet extends StatefulWidget {
  const _ExpenseSheet();

  @override
  State<_ExpenseSheet> createState() => _ExpenseSheetState();
}

class _ExpenseSheetState extends State<_ExpenseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _category = TextEditingController();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  PaymentMode _mode = PaymentMode.cash;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _category.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (picked != null) {
      setState(
        () => _date = DateTime(
          picked.year,
          picked.month,
          picked.day,
          now.hour,
          now.minute,
        ),
      );
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    await context.read<ExpenseRepository>().add(
      Expense(
        spentAt: _date,
        category: _category.text,
        amount: Money.tryParse(_amount.text)!,
        paymentMode: _mode,
        note: _note.text,
      ),
    );
    if (!mounted) return;
    Navigator.pop(context);
    showSnack(context, l10n.expenseSaved);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.expenseAdd,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final c in expenseCategories)
                    ChoiceChip(
                      label: Text(c),
                      selected: _category.text == c,
                      onSelected: (_) => setState(() => _category.text = c),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('expenseCategoryField'),
                controller: _category,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.expenseCategory),
                onChanged: (_) => setState(() {}),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? l10n.errRequired : null,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: MoneyField(
                      key: const Key('expenseAmountField'),
                      controller: _amount,
                      label: l10n.expenseAmount,
                      isRequired: true,
                      extraValidator: (m) =>
                          m.isPositive ? null : l10n.errPaymentZero,
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 56),
                    ),
                    onPressed: _pickDate,
                    icon: const Icon(Icons.event_outlined),
                    label: Text(formatDate(_date)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SegmentedButton<PaymentMode>(
                showSelectedIcon: false,
                segments: [
                  for (final m in [
                    PaymentMode.cash,
                    PaymentMode.upi,
                    PaymentMode.card,
                  ])
                    ButtonSegment(value: m, label: Text(m.label(l10n))),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _note,
                decoration: InputDecoration(labelText: l10n.stockNote),
              ),
              const SizedBox(height: 20),
              FilledButton(
                key: const Key('saveExpenseButton'),
                onPressed: _saving ? null : _save,
                child: Text(_saving ? l10n.saving : l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
