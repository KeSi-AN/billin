import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/billing/domain/bill.dart';

part 'party.freezed.dart';

enum PartyType { customer, supplier }

/// A customer (supplier from Phase 4) and what they owe.
@freezed
abstract class Party with _$Party {
  const factory Party({
    required String name,
    int? id,
    String? phone,
    String? addressLine,
    String? gstin,
    String? notes,

    /// GST state code (place of supply). Filled from the GSTIN if given.
    String? stateCode,
    @Default(PartyType.customer) PartyType type,

    /// What they owe the shop (+), or an advance the shop holds (−).
    /// Read-only here: only the party ledger changes it.
    @Default(Money.zero) Money balance,
  }) = _Party;

  const Party._();

  bool get hasDue => balance > Money.zero;
}

enum EntryType {
  opening,
  sale,
  payment,
  cancel,
  adjust,

  /// Supplier bill not yet paid (+ = the shop owes more). Phase 4.
  purchase,

  /// Goods returned against a credit bill (− = they owe less). Phase 4.
  salesReturn,
}

/// One line in a customer's khata.
class PartyEntry {
  const PartyEntry({
    required this.id,
    required this.partyId,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.at,
    this.billId,
    this.invoiceNo,
    this.paymentMode,
    this.note,
  });

  final int id;
  final int partyId;
  final EntryType type;

  /// + they owe more, − they paid.
  final Money amount;
  final Money balanceAfter;
  final DateTime at;
  final int? billId;
  final String? invoiceNo;
  final PaymentMode? paymentMode;
  final String? note;
}

enum PartySort { name, dueHighFirst, recent }

@immutable
class PartyFilter {
  const PartyFilter({
    this.query = '',
    this.onlyWithDues = false,
    this.sort = PartySort.name,
    this.type = PartyType.customer,
  });

  final String query;
  final bool onlyWithDues;
  final PartySort sort;
  final PartyType type;

  PartyFilter copyWith({String? query, bool? onlyWithDues, PartySort? sort}) =>
      PartyFilter(
        query: query ?? this.query,
        onlyWithDues: onlyWithDues ?? this.onlyWithDues,
        sort: sort ?? this.sort,
        type: type,
      );

  @override
  bool operator ==(Object other) =>
      other is PartyFilter &&
      other.query == query &&
      other.onlyWithDues == onlyWithDues &&
      other.sort == sort &&
      other.type == type;

  @override
  int get hashCode => Object.hash(query, onlyWithDues, sort, type);
}

class PartyHasBalanceException implements Exception {
  const PartyHasBalanceException(this.balance);

  final Money balance;

  @override
  String toString() => 'Settle the balance (${balance.format()}) first';
}

class DuplicatePhoneException implements Exception {
  const DuplicatePhoneException(this.existingName);

  final String existingName;

  @override
  String toString() => 'Phone number already used by "$existingName"';
}

abstract interface class PartyRepository {
  Stream<List<Party>> watchAll({PartyFilter filter = const PartyFilter()});

  /// Sum of positive balances of one type: what customers owe the shop, or
  /// what the shop owes suppliers (advances not netted off).
  Stream<Money> watchTotalDue({PartyType type = PartyType.customer});

  Future<Party?> byId(int id);

  Stream<Party?> watch(int id);

  /// Inserts or updates. [openingDue] (new customers only) records money
  /// they already owed before using the app.
  /// Throws [DuplicatePhoneException] if another customer has the phone.
  Future<Party> save(Party party, {Money openingDue = Money.zero});

  /// Hides the customer. Throws [PartyHasBalanceException] unless settled.
  Future<void> delete(int id);

  /// Newest first.
  Stream<List<PartyEntry>> watchEntries(int partyId);

  /// Oldest first, between two dates (for a statement).
  Future<List<PartyEntry>> entriesBetween(
    int partyId,
    DateTime from,
    DateTime to,
  );

  /// Every party's entries in a period, oldest first (for the day book).
  Future<List<PartyEntry>> allEntriesBetween(DateTime from, DateTime to);

  /// Money received against dues (a full or partial settlement).
  Future<void> receivePayment(
    int partyId,
    Money amount, {
    PaymentMode mode = PaymentMode.cash,
    String? note,
  });
}
