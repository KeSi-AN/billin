import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/billing/domain/invoice_number.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

class BillingSettingsPage extends StatefulWidget {
  const BillingSettingsPage({super.key});

  @override
  State<BillingSettingsPage> createState() => _BillingSettingsPageState();
}

class _BillingSettingsPageState extends State<BillingSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _prefix = TextEditingController();
  final _upi = TextEditingController();
  final _footer = TextEditingController();
  AppSettingsData? _settings;

  @override
  void initState() {
    super.initState();
    unawaited(
      context.read<SettingsRepository>().load().then((s) {
        if (!mounted) return;
        _prefix.text = s.invoicePrefix;
        _upi.text = s.upiId ?? '';
        _footer.text = s.receiptFooter ?? '';
        setState(() => _settings = s);
      }),
    );
  }

  @override
  void dispose() {
    _prefix.dispose();
    _upi.dispose();
    _footer.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context);
    await context.read<SettingsRepository>().save(
      _settings!.copyWith(
        invoicePrefix: _prefix.text.trim().toUpperCase(),
        upiId: _upi.text.trim(),
        receiptFooter: _footer.text.trim(),
      ),
    );
    if (!mounted) return;
    showSnack(context, l10n.settingsSaved);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = _settings;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.billingSettingsTitle)),
      body: settings == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ListenableBuilder(
                    listenable: _prefix,
                    builder: (context, _) {
                      final prefix = _prefix.text.trim().toUpperCase();
                      final example = InvoiceNumber.format(
                        prefix: InvoiceNumber.isValidPrefix(prefix)
                            ? prefix
                            : '',
                        year: FinancialYear.of(DateTime.now()),
                        sequence: 1,
                      );
                      return TextFormField(
                        key: const Key('invoicePrefixField'),
                        controller: _prefix,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: l10n.fieldInvoicePrefix,
                          helperText: l10n.invoicePrefixHelp(example),
                        ),
                        validator: (v) =>
                            InvoiceNumber.isValidPrefix(
                              (v ?? '').trim().toUpperCase(),
                            )
                            ? null
                            : l10n.errInvoicePrefix,
                      );
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.fieldRoundToRupee),
                    value: settings.roundToRupee,
                    onChanged: (v) => setState(
                      () => _settings = settings.copyWith(roundToRupee: v),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('upiIdField'),
                    controller: _upi,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.fieldUpiId,
                      helperText: l10n.upiIdHelp,
                    ),
                    validator: (v) =>
                        (v ?? '').trim().isEmpty || isValidUpiId(v!)
                        ? null
                        : l10n.errUpiId,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _footer,
                    maxLength: 64,
                    decoration: InputDecoration(
                      labelText: l10n.fieldReceiptFooter,
                      hintText: l10n.receiptFooterHint,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const Key('saveSettingsButton'),
                    onPressed: _save,
                    child: Text(l10n.save),
                  ),
                ],
              ),
            ),
    );
  }
}
