import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shop_app/core/format/dates.dart';
import 'package:shop_app/core/money/money.dart';
import 'package:shop_app/core/widgets/form_fields.dart';
import 'package:shop_app/features/customers/domain/party.dart';
import 'package:shop_app/features/purchases/domain/purchase.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Picks a photo from the camera or gallery; returns its path or `null`.
typedef PickBillPhoto = Future<String?> Function(ImageSource source);

/// Puts a copy of a saved photo where the user can find it (Downloads).
typedef PublishBillPhoto = Future<void> Function(String path, String name);

/// Keeps the picked photo in the app as [name] (numbered if taken);
/// returns where it was stored.
typedef StoreBillPhoto = Future<String> Function(String source, String name);

Future<String> _storeInApp(String source, String name) async {
  final dir = Directory(
    p.join((await getApplicationSupportDirectory()).path, 'purchases'),
  );
  await dir.create(recursive: true);
  final ext = p.extension(name);
  final base = p.basenameWithoutExtension(name);
  var target = p.join(dir.path, name);
  for (var n = 2; File(target).existsSync(); n++) {
    target = p.join(dir.path, '${base}_$n$ext');
  }
  await File(source).copy(target);
  return target;
}

Future<String?> _pickWithSystem(ImageSource source) async =>
    (await ImagePicker().pickImage(
      source: source,
      // Big enough to read the bill's small print, small enough to keep.
      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 85,
    ))?.path;

Future<void> _publishToDownloads(String path, String name) async {
  try {
    await const MethodChannel('shop_app/downloads')
        .invokeMethod<bool>('savePhoto', {'path': path, 'name': name});
  } on Object {
    // The copy in the app is the record; Downloads is a convenience.
  }
}

/// Record a purchase as just a photo of the supplier's bill, its date and
/// the supplier (and the amount, if wanted). Nothing to type item by item,
/// so it's quick and there's little to lose.
class PhotoPurchasePage extends StatefulWidget {
  const PhotoPurchasePage({
    this.pickPhoto = _pickWithSystem,
    this.publish = _publishToDownloads,
    this.store = _storeInApp,
    super.key,
  });

  final PickBillPhoto pickPhoto;
  final PublishBillPhoto publish;
  final StoreBillPhoto store;

  @override
  State<PhotoPurchasePage> createState() => _PhotoPurchasePageState();
}

class _PhotoPurchasePageState extends State<PhotoPurchasePage> {
  final _formKey = GlobalKey<FormState>();
  final _supplier = TextEditingController();
  final _amount = TextEditingController();
  final _supplierFocus = FocusNode();
  String? _photo;
  DateTime _date = DateTime.now();
  bool _saving = false;
  List<Party> _suppliers = const [];
  StreamSubscription<List<Party>>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = context
        .read<PartyRepository>()
        .watchAll(filter: const PartyFilter(type: PartyType.supplier))
        .listen((s) => setState(() => _suppliers = s));
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    _supplier.dispose();
    _supplierFocus.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _choosePhoto() async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.logoFromCamera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.logoFromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final path = await widget.pickPhoto(source);
    if (path != null && mounted) setState(() => _photo = path);
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

  /// `Purchase_2026-11-22_Ravi Textiles.jpg`.
  static String _fileName(DateTime date, String supplier, String ext) {
    final safe = supplier
        .replaceAll(RegExp(r'[\\/:*?"<>|]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return [
          'Purchase',
          DateFormat('yyyy-MM-dd').format(date),
          if (safe.isNotEmpty) safe,
        ].join('_') +
        ext;
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final photo = _photo;
    if (photo == null) {
      showSnack(context, l10n.photoPurchaseNeedPhoto);
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final repo = context.read<PurchaseRepository>();
    try {
      final supplierText = _supplier.text.trim();
      final known = _suppliers
          .where((s) => s.name.toLowerCase() == supplierText.toLowerCase())
          .firstOrNull;
      // Keep the photo in the app (the gallery copy may be deleted).
      final ext = p.extension(photo).toLowerCase().isEmpty
          ? '.jpg'
          : p.extension(photo).toLowerCase();
      final stored = await widget.store(
        photo,
        _fileName(_date, known?.name ?? supplierText, ext),
      );
      final name = p.basename(stored);

      await repo.create(
        PurchaseDraft.photo(
          photoPath: stored,
          purchasedAt: _date,
          partyId: known?.id,
          supplierName: known == null ? supplierText : null,
          amount: Money.tryParse(_amount.text.trim()) ?? Money.zero,
        ),
      );
      await widget.publish(stored, name);
      if (!mounted) return;
      showSnack(context, l10n.photoPurchaseSaved);
      context.pop();
    } on Object catch (e) {
      if (mounted) showSnack(context, '$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final photo = _photo;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.photoPurchaseTitle)),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            16 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: FilledButton.icon(
            key: const Key('photoPurchaseSave'),
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.check),
            label: Text(l10n.save),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            InkWell(
              key: const Key('photoPurchasePhoto'),
              onTap: _saving ? null : _choosePhoto,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: photo == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_a_photo_outlined, size: 48),
                          const SizedBox(height: 8),
                          Text(l10n.photoPurchaseTakePhoto),
                        ],
                      )
                    : Image.file(File(photo), fit: BoxFit.contain),
              ),
            ),
            if (photo != null)
              Align(
                child: TextButton.icon(
                  style: TextButton.styleFrom(minimumSize: const Size(0, 40)),
                  onPressed: _saving ? null : _choosePhoto,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.photoPurchaseRetake),
                ),
              ),
            const SizedBox(height: 16),
            Autocomplete<String>(
              optionsBuilder: (v) {
                final q = v.text.trim().toLowerCase();
                if (q.isEmpty) return const [];
                return [
                  for (final s in _suppliers)
                    if (s.name.toLowerCase().contains(q)) s.name,
                ];
              },
              textEditingController: _supplier,
              focusNode: _supplierFocus,
              fieldViewBuilder: (context, controller, focus, onSubmit) {
                return TextFormField(
                  key: const Key('photoPurchaseSupplier'),
                  controller: controller,
                  focusNode: focus,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.photoPurchaseSupplier,
                  ),
                  validator: (v) => (v ?? '').trim().isEmpty
                      ? l10n.photoPurchaseSupplierRequired
                      : null,
                );
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              key: const Key('photoPurchaseDate'),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(l10n.photoPurchaseDate),
              subtitle: Text(formatDate(_date)),
              onTap: _saving ? null : _pickDate,
            ),
            const SizedBox(height: 8),
            MoneyField(
              key: const Key('photoPurchaseAmount'),
              controller: _amount,
              label: l10n.photoPurchaseAmount,
              helperText: l10n.photoPurchaseAmountHelp,
            ),
          ],
        ),
      ),
    );
  }
}
