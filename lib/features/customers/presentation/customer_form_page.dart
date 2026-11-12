import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/india/gstin.dart';
import 'package:shop_app/core/india/phone.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/customers/domain/contact_picker.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Add or edit a customer. Pops with the saved [Party].
class CustomerFormPage extends StatefulWidget {
  const CustomerFormPage({this.partyId, this.initialName, super.key});

  final int? partyId;
  final String? initialName;

  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _gstin = TextEditingController();
  final _notes = TextEditingController();
  final _opening = TextEditingController();
  Party? _existing;
  String? _phoneError;
  bool _loading = true;
  bool _saving = false;

  bool get _isNew => widget.partyId == null;

  @override
  void initState() {
    super.initState();
    _name.text = widget.initialName ?? '';
    unawaited(_load());
  }

  Future<void> _load() async {
    final id = widget.partyId;
    if (id != null) {
      final p = await context.read<PartyRepository>().byId(id);
      if (p != null) {
        _existing = p;
        _name.text = p.name;
        _phone.text = p.phone ?? '';
        _address.text = p.addressLine ?? '';
        _gstin.text = p.gstin ?? '';
        _notes.text = p.notes ?? '';
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _address, _gstin, _notes, _opening]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _fromContacts() async {
    final contact = await context.read<ContactPicker>().pick();
    if (contact == null || !mounted) return;
    setState(() {
      if (_name.text.trim().isEmpty) _name.text = contact.name;
      _phone.text = IndianPhone.normalize(contact.phone);
    });
  }

  Future<void> _save() async {
    setState(() => _phoneError = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context);
    final repo = context.read<PartyRepository>();
    try {
      final saved = await repo.save(
        (_existing ?? const Party(name: '')).copyWith(
          name: _name.text,
          phone: _phone.text,
          addressLine: _address.text,
          gstin: _gstin.text.trim().isEmpty
              ? null
              : Gstin.normalize(_gstin.text),
          notes: _notes.text,
        ),
        openingDue: Money.tryParse(_opening.text) ?? Money.zero,
      );
      if (!mounted) return;
      showSnack(context, l10n.customerSaved);
      context.pop(saved);
    } on DuplicatePhoneException catch (e) {
      setState(() {
        _phoneError = l10n.errDuplicatePhone(e.existingName);
        _saving = false;
      });
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final p = _existing!;
    if (!p.balance.isZero) {
      showSnack(context, l10n.customerHasBalance(p.balance.format()));
      return;
    }
    final ok = await confirm(
      context,
      title: l10n.customerDeleteConfirm(p.name),
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!ok || !mounted) return;
    await context.read<PartyRepository>().delete(p.id!);
    if (!mounted) return;
    showSnack(context, l10n.customerDeleted);
    // Back past the (now hidden) customer's page too.
    context
      ..pop()
      ..pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const gap = SizedBox(height: 16);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? l10n.customerNew : l10n.customerEdit),
        actions: [
          if (_existing != null)
            IconButton(
              tooltip: l10n.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  OutlinedButton.icon(
                    key: const Key('pickContactButton'),
                    onPressed: _fromContacts,
                    icon: const Icon(Icons.contacts_outlined),
                    label: Text(l10n.pickFromContacts),
                  ),
                  gap,
                  TextFormField(
                    key: const Key('customerNameField'),
                    controller: _name,
                    autofocus: _isNew && _name.text.isEmpty,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: l10n.fieldName),
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? l10n.errRequired : null,
                  ),
                  gap,
                  TextFormField(
                    key: const Key('customerPhoneField'),
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: l10n.fieldPhone,
                      helperText: l10n.optional,
                      prefixText: '+91 ',
                      errorText: _phoneError,
                    ),
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ||
                            IndianPhone.isValidMobile(v!)
                        ? null
                        : l10n.errPhoneInvalid,
                  ),
                  gap,
                  TextFormField(
                    controller: _address,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: l10n.fieldAddress,
                      helperText: l10n.optional,
                    ),
                  ),
                  gap,
                  TextFormField(
                    controller: _gstin,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: l10n.fieldGstin,
                      helperText: l10n.optional,
                    ),
                    validator: (v) =>
                        (v ?? '').trim().isEmpty || Gstin.validate(v!) == null
                        ? null
                        : l10n.errGstinInvalid,
                  ),
                  gap,
                  TextFormField(
                    controller: _notes,
                    decoration: InputDecoration(
                      labelText: l10n.fieldNotes,
                      helperText: l10n.optional,
                    ),
                  ),
                  if (_isNew) ...[
                    gap,
                    MoneyField(
                      key: const Key('openingDueField'),
                      controller: _opening,
                      label: l10n.fieldOpeningDue,
                      helperText: l10n.openingDueHelp,
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('saveCustomerButton'),
                    onPressed: _saving ? null : _save,
                    child: Text(_saving ? l10n.saving : l10n.save),
                  ),
                ],
              ),
            ),
    );
  }
}
