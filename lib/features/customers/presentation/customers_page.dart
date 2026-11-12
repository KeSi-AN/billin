import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/customers/presentation/balance_text.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Customers with their dues.
class CustomersPage extends StatefulWidget {
  const CustomersPage({this.type = PartyType.customer, super.key});

  final PartyType type;

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  late PartyFilter _filter = PartyFilter(type: widget.type);

  bool get _suppliers => widget.type == PartyType.supplier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final repo = context.read<PartyRepository>();
    return Scaffold(
      appBar: AppBar(
        title: Text(_suppliers ? l10n.suppliersTitle : l10n.customersTitle),
        actions: [
          PopupMenuButton<PartySort>(
            tooltip: l10n.sortBy,
            icon: const Icon(Icons.sort),
            initialValue: _filter.sort,
            onSelected: (s) =>
                setState(() => _filter = _filter.copyWith(sort: s)),
            itemBuilder: (context) => [
              PopupMenuItem(value: PartySort.name, child: Text(l10n.sortName)),
              PopupMenuItem(
                value: PartySort.dueHighFirst,
                child: Text(l10n.sortDue),
              ),
              PopupMenuItem(
                value: PartySort.recent,
                child: Text(l10n.sortRecent),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('addCustomerButton'),
        onPressed: () => context.push(AppRoutes.newParty(widget.type)),
        icon: const Icon(Icons.person_add_alt),
        label: Text(_suppliers ? l10n.supplierAdd : l10n.customerAdd),
      ),
      body: Column(
        children: [
          StreamBuilder<Money>(
            stream: repo.watchTotalDue(type: widget.type),
            builder: (context, snapshot) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Card(
                child: ListTile(
                  title: Text(
                    _suppliers
                        ? l10n.suppliersTotalOwed
                        : l10n.customersTotalDue,
                    style: text.labelLarge,
                  ),
                  trailing: Text(
                    (snapshot.data ?? Money.zero).format(),
                    key: const Key('totalDue'),
                    style: text.headlineSmall,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.customersSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) =>
                  setState(() => _filter = _filter.copyWith(query: v)),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FilterChip(
                key: const Key('withDuesChip'),
                label: Text(l10n.filterWithDues),
                selected: _filter.onlyWithDues,
                onSelected: (v) =>
                    setState(() => _filter = _filter.copyWith(onlyWithDues: v)),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Party>>(
              key: ValueKey(_filter),
              stream: repo.watchAll(filter: _filter),
              builder: (context, snapshot) {
                final parties = snapshot.data;
                if (parties == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (parties.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        _filter == PartyFilter(type: widget.type)
                            ? (_suppliers
                                  ? l10n.suppliersEmpty
                                  : l10n.customersEmpty)
                            : l10n.customersNoMatch,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: parties.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) => CustomerTile(
                    party: parties[i],
                    onTap: () => context.push(
                      AppRoutes.party(widget.type, parties[i].id!),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerTile extends StatelessWidget {
  const CustomerTile({required this.party, this.onTap, super.key});

  final Party party;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final initial = party.name.trim().isEmpty ? '?' : party.name.trim()[0];
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(child: Text(initial.toUpperCase())),
      title: Text(party.name),
      subtitle: party.phone == null ? null : Text('+91 ${party.phone}'),
      trailing: BalanceText(
        party.balance,
        supplier: party.type == PartyType.supplier,
      ),
    );
  }
}
