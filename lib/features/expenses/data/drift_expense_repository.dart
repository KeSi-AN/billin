import 'package:drift/drift.dart';
import 'package:shop_app/core/db/app_database.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/expenses/domain/expense.dart';

class DriftExpenseRepository implements ExpenseRepository {
  DriftExpenseRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Expense> add(Expense e) async {
    if (!e.amount.isPositive) {
      throw ArgumentError.value(e.amount, 'amount', 'must be positive');
    }
    final note = e.note?.trim();
    final id = await _db
        .into(_db.expenses)
        .insert(
          ExpensesCompanion.insert(
            spentAt: e.spentAt,
            category: e.category.trim(),
            amountPaise: e.amount.paise,
            paymentMode: e.paymentMode.name,
            note: Value(note == null || note.isEmpty ? null : note),
          ),
        );
    return Expense(
      id: id,
      spentAt: e.spentAt,
      category: e.category.trim(),
      amount: e.amount,
      paymentMode: e.paymentMode,
      note: e.note,
    );
  }

  @override
  Future<void> delete(int id) async {
    await (_db.update(_db.expenses)..where((x) => x.id.equals(id))).write(
      const ExpensesCompanion(isDeleted: Value(true)),
    );
  }

  @override
  Stream<List<Expense>> watchBetween(DateTime from, DateTime to) =>
      (_db.select(_db.expenses)
            ..where(
              (x) =>
                  x.isDeleted.equals(false) &
                  x.spentAt.isBiggerOrEqualValue(from) &
                  x.spentAt.isSmallerThanValue(to),
            )
            ..orderBy([(x) => OrderingTerm.desc(x.spentAt)]))
          .watch()
          .map(
            (rows) => [
              for (final r in rows)
                Expense(
                  id: r.id,
                  spentAt: r.spentAt,
                  category: r.category,
                  amount: Money.paise(r.amountPaise),
                  paymentMode: PaymentMode.values.byName(r.paymentMode),
                  note: r.note,
                ),
            ],
          );
}
