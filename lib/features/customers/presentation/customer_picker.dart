import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/customers/presentation/customers_page.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Search customers, or add a new one. Returns the chosen [Party].
Future<Party?> showCustomerPicker(
  BuildContext context, {
  PartyType type = PartyType.customer,
}) => showModalBottomSheet<Party>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useSafeArea: true,
  builder: (_) => RepositoryProvider.value(
    value: context.read<PartyRepository>(),
    child: _CustomerPicker(type: type),
  ),
);

class _CustomerPicker extends StatefulWidget {
  const _CustomerPicker({required this.type});

  final PartyType type;

  @override
  State<_CustomerPicker> createState() => _CustomerPickerState();
}

class _CustomerPickerState extends State<_CustomerPicker> {
  String _query = '';

  Future<void> _addNew() async {
    final party = await context.push<Party>(
      AppRoutes.newParty(widget.type, name: _query.trim()),
    );
    if (party != null && mounted) Navigator.pop(context, party);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                key: const Key('customerPickerSearch'),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.customersSearchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            ListTile(
              key: const Key('pickerNewCustomer'),
              leading: const Icon(Icons.person_add_alt),
              title: Text(
                _query.trim().isEmpty
                    ? (widget.type == PartyType.supplier
                          ? l10n.supplierNew
                          : l10n.customerNew)
                    : l10n.customerPickerNew(_query.trim()),
              ),
              onTap: _addNew,
            ),
            const Divider(height: 1),
            Expanded(
              child: StreamBuilder<List<Party>>(
                key: ValueKey(_query),
                stream: context.read<PartyRepository>().watchAll(
                  filter: PartyFilter(
                    query: _query,
                    sort: PartySort.recent,
                    type: widget.type,
                  ),
                ),
                builder: (context, snapshot) => ListView(
                  children: [
                    for (final p in snapshot.data ?? const <Party>[])
                      CustomerTile(
                        party: p,
                        onTap: () => Navigator.pop(context, p),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
