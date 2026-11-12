import 'package:shop_app/features/billing/domain/bill.dart';
import 'package:shop_app/features/billing/domain/credit_note.dart';
import 'package:shop_app/features/expenses/domain/expense.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/features/reports/domain/gst_report.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';

/// Gathers everything recorded in a period for [GstReport].
class ReportLoader {
  const ReportLoader({
    required this.shopProfiles,
    required this.bills,
    required this.returns,
    required this.purchases,
    required this.expenses,
  });

  final ShopProfileRepository shopProfiles;
  final BillRepository bills;
  final ReturnsRepository returns;
  final PurchaseRepository purchases;
  final ExpenseRepository expenses;

  Future<ReportInput> load(DateTime from, DateTime to) async {
    final shop = (await shopProfiles.load())!;
    final periodBills = await bills.billsBetween(from, to);
    final notes = await returns.between(from, to);
    final byId = {for (final b in periodBills) b.id: b};
    // A return this month may be against a bill from an earlier month.
    for (final n in notes) {
      if (!byId.containsKey(n.billId)) {
        final bill = await bills.byId(n.billId);
        if (bill != null) byId[n.billId] = bill;
      }
    }
    return ReportInput(
      shop: shop,
      from: from,
      to: to,
      bills: periodBills,
      creditNotes: notes,
      creditNoteBills: {for (final n in notes) n.billId: byId[n.billId]!},
      purchases: (await purchases.watchBetween(from, to).first).reversed
          .toList(),
      expenses: await expenses.watchBetween(from, to).first,
    );
  }
}
