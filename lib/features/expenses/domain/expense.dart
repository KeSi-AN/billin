import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';

/// Common shop expenses, offered as quick choices (any text is allowed).
const expenseCategories = [
  'Rent',
  'Salary',
  'Electricity',
  'Transport',
  'Tea & snacks',
  'Repairs',
  'Phone & internet',
  'Other',
];

class Expense {
  const Expense({
    required this.spentAt,
    required this.category,
    required this.amount,
    this.id,
    this.paymentMode = PaymentMode.cash,
    this.note,
  });

  final int? id;
  final DateTime spentAt;
  final String category;
  final Money amount;
  final PaymentMode paymentMode;
  final String? note;
}

abstract interface class ExpenseRepository {
  Future<Expense> add(Expense expense);

  Future<void> delete(int id);

  /// Newest first; `from <= spentAt < to`.
  Stream<List<Expense>> watchBetween(DateTime from, DateTime to);
}
