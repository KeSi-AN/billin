import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/app/router.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/printing/data/printer_service.dart';
import 'package:shop_app/features/printing/domain/mono_image.dart';
import 'package:shop_app/features/printing/domain/receipt_formatter.dart';
import 'package:shop_app/features/printing/domain/receipt_template.dart';
import 'package:shop_app/features/printing/domain/sample_bill.dart';
import 'package:shop_app/features/printing/presentation/print_error_text.dart';
import 'package:shop_app/features/printing/presentation/receipt_preview.dart';
import 'package:shop_app/features/settings/domain/app_settings.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';
import 'package:shop_app/features/shop_profile/presentation/cubit/shop_profile_cubit.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Edit what goes on the printed bill, see it, and print a sample.
/// Changes save as you go.
class BillTemplatePage extends StatefulWidget {
  const BillTemplatePage({super.key});

  @override
  State<BillTemplatePage> createState() => _BillTemplatePageState();
}

class _BillTemplatePageState extends State<BillTemplatePage> {
  AppSettingsData? _settings;
  final _addressLabel = TextEditingController();
  final _headerNote = TextEditingController();
  final _qrCaption = TextEditingController();
  final _footer = TextEditingController();
  final _upi = TextEditingController();
  Timer? _saveTimer;
  late final SettingsRepository _repo = context.read<SettingsRepository>();
  bool _printing = false;

  @override
  void initState() {
    super.initState();
    unawaited(
      _repo.load().then((s) {
        if (!mounted) return;
        final t = s.receiptTemplate;
        _addressLabel.text = t.addressLabel;
        _headerNote.text = t.headerNote;
        _qrCaption.text = t.qrCaption;
        _footer.text = t.footer;
        _upi.text = s.upiId ?? '';
        setState(() => _settings = s);
      }),
    );
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    // Don't lose a change typed just before leaving.
    final s = _settings;
    if (s != null) unawaited(_repo.save(s));
    for (final c in [_addressLabel, _headerNote, _qrCaption, _footer, _upi]) {
      c.dispose();
    }
    super.dispose();
  }

  ReceiptTemplate get _t => _settings!.receiptTemplate;

  void _set(ReceiptTemplate t, {String? upiId}) {
    setState(
      () => _settings = _settings!.copyWith(
        receiptTemplate: t,
        upiId: upiId ?? _settings!.upiId,
      ),
    );
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 400), () {
      final s = _settings;
      if (s != null) unawaited(_repo.save(s));
    });
  }

  ShopProfile? get _shop => switch (context.read<ShopProfileCubit>().state) {
    ShopProfileReady(:final profile) => profile,
    _ => null,
  };

  Future<void> _printSample() async {
    final l10n = AppLocalizations.of(context);
    final shop = _shop;
    final s = _settings;
    if (shop == null || s == null) return;
    final printer = context.read<PrinterService>();
    setState(() => _printing = true);
    try {
      final bytes = ReceiptFormatter(width: s.paperWidth.charsPerLine).bytes(
        sampleBill(gst: shop.gstin != null),
        shop,
        s,
        logo: await printer.logos.logoFor(shop, s),
      );
      await printer.printBytes(bytes);
      if (mounted) showSnack(context, l10n.printed);
    } on PrintException catch (e) {
      if (mounted) showSnack(context, printErrorText(l10n, e));
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }

  Future<void> _showPreview() async {
    final shop = _shop;
    final s = _settings;
    if (shop == null || s == null) return;
    final logo = await context.read<PrinterService>().logos.logoFor(shop, s);
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _PreviewSheet(settings: s, shop: shop, logo: logo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s = _settings;
    final shop = context.watch<ShopProfileCubit>().state;
    final profile = shop is ShopProfileReady ? shop.profile : null;
    if (s == null || profile == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.tplTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final t = _t;
    final text = Theme.of(context).textTheme;
    Widget section(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(title, style: text.titleSmall),
    );
    Widget toggle(
      String key,
      String title,
      bool value,
      ReceiptTemplate Function(bool) change, {
      String? subtitle,
    }) => SwitchListTile(
      key: Key('tpl_$key'),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      value: value,
      onChanged: (v) => _set(change(v)),
    );
    Widget field(
      String key,
      TextEditingController c,
      String label,
      ReceiptTemplate Function(String) change, {
      String? hint,
      int maxLines = 1,
    }) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: TextField(
        key: Key('tpl_$key'),
        controller: c,
        maxLines: maxLines,
        minLines: 1,
        decoration: InputDecoration(labelText: label, hintText: hint),
        onChanged: (v) => _set(change(v)),
      ),
    );
    final upiValid = _upi.text.trim().isEmpty || isValidUpiId(_upi.text);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tplTitle),
        actions: [
          IconButton(
            key: const Key('tplPreviewButton'),
            tooltip: l10n.tplPreview,
            icon: const Icon(Icons.visibility_outlined),
            onPressed: _showPreview,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showPreview,
                  icon: const Icon(Icons.visibility_outlined),
                  label: Text(l10n.tplPreview),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  key: const Key('tplPrintSampleButton'),
                  onPressed: _printing || s.printerAddress == null
                      ? null
                      : _printSample,
                  icon: const Icon(Icons.print_outlined),
                  label: Text(_printing ? l10n.printing : l10n.tplPrintSample),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          section(l10n.tplHeader),
          toggle(
            'logo',
            l10n.tplLogo,
            t.showLogo,
            (v) => t.copyWith(showLogo: v),
            subtitle: profile.logoPath == null ? l10n.tplLogoNone : null,
          ),
          if (profile.logoPath == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => context.push(AppRoutes.editShop),
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: Text(l10n.tplEditShop),
                ),
              ),
            ),
          if (t.showLogo && profile.logoPath != null)
            ListTile(
              title: Text(l10n.tplLogoSize),
              subtitle: Slider(
                key: const Key('tpl_logoSize'),
                value: t.logoWidthPercent.toDouble(),
                min: 30,
                max: 100,
                divisions: 7,
                label: '${t.logoWidthPercent}%',
                onChanged: (v) => _set(t.copyWith(logoWidthPercent: v.round())),
              ),
            ),
          toggle(
            'shopName',
            l10n.tplShopName,
            t.showShopName,
            (v) => t.copyWith(showShopName: v),
          ),
          toggle(
            'phone',
            l10n.tplPhone,
            t.showPhone,
            (v) => t.copyWith(showPhone: v),
          ),
          toggle(
            'address',
            l10n.tplAddress,
            t.showAddress,
            (v) => t.copyWith(showAddress: v),
          ),
          if (t.showAddress)
            field(
              'addressLabel',
              _addressLabel,
              l10n.tplAddressLabel,
              (v) => t.copyWith(addressLabel: v),
            ),
          toggle(
            'gstin',
            l10n.tplGstin,
            t.showGstin,
            (v) => t.copyWith(showGstin: v),
            subtitle: profile.gstin ?? l10n.tplGstinNone,
          ),
          field(
            'headerNote',
            _headerNote,
            l10n.tplHeaderNote,
            (v) => t.copyWith(headerNote: v),
            hint: l10n.tplHeaderNoteHint,
            maxLines: 3,
          ),
          section(l10n.tplDetails),
          toggle(
            'billNo',
            l10n.tplBillNo,
            t.showBillNo,
            (v) => t.copyWith(showBillNo: v),
          ),
          toggle(
            'customer',
            l10n.tplCustomer,
            t.showCustomer,
            (v) => t.copyWith(showCustomer: v),
          ),
          toggle(
            'rate',
            l10n.tplRate,
            t.showRate,
            (v) => t.copyWith(showRate: v),
          ),
          toggle(
            'totalQty',
            l10n.tplTotalQty,
            t.showTotalQty,
            (v) => t.copyWith(showTotalQty: v),
          ),
          toggle(
            'bigTotal',
            l10n.tplBigTotal,
            t.bigTotal,
            (v) => t.copyWith(bigTotal: v),
          ),
          toggle(
            'gstSummary',
            l10n.tplGstSummary,
            t.showGstSummary,
            (v) => t.copyWith(showGstSummary: v),
          ),
          section(l10n.tplQr),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(l10n.tplQrHelp, style: text.bodySmall),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<QrMode>(
              key: const Key('tpl_qrMode'),
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: QrMode.off, label: Text(l10n.tplQrOff)),
                ButtonSegment(
                  value: QrMode.upiAndCredit,
                  label: Text(l10n.tplQrUpi),
                ),
                ButtonSegment(value: QrMode.always, label: Text(l10n.tplQrAll)),
              ],
              selected: {t.qrMode},
              onSelectionChanged: (v) => _set(t.copyWith(qrMode: v.first)),
            ),
          ),
          if (t.qrMode != QrMode.off) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                key: const Key('tpl_upiId'),
                controller: _upi,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.fieldUpiId,
                  helperText: _upi.text.trim().isEmpty
                      ? l10n.tplQrNeedsUpi
                      : l10n.upiIdHelp,
                  errorText: upiValid ? null : l10n.errUpiId,
                ),
                onChanged: (v) {
                  if (v.trim().isEmpty || isValidUpiId(v)) {
                    _set(t, upiId: v.trim());
                  } else {
                    setState(() {});
                  }
                },
              ),
            ),
            field(
              'qrCaption',
              _qrCaption,
              l10n.tplQrCaption,
              (v) => t.copyWith(qrCaption: v),
            ),
          ],
          section(l10n.tplFooter),
          field(
            'footer',
            _footer,
            l10n.tplFooter,
            (v) => t.copyWith(footer: v),
            hint: l10n.tplFooterHint,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

class _PreviewSheet extends StatelessWidget {
  const _PreviewSheet({
    required this.settings,
    required this.shop,
    required this.logo,
  });

  final AppSettingsData settings;
  final ShopProfile shop;
  final MonoImage? logo;

  @override
  Widget build(BuildContext context) {
    final width = settings.paperWidth.charsPerLine;
    final lines = ReceiptFormatter(width: width)
        .lines(sampleBill(gst: shop.gstin != null), shop, settings);
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.85,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Material(
          elevation: 2,
          child: ReceiptPreview(lines: lines, charsPerLine: width, logo: logo),
        ),
      ),
    );
  }
}
