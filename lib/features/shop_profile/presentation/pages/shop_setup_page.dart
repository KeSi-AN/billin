import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shop_app/core/india/gstin.dart';
import 'package:shop_app/core/india/indian_states.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_validators.dart';
import 'package:shop_app/features/shop_profile/presentation/cubit/shop_profile_cubit.dart';
import 'package:shop_app/features/shop_profile/presentation/cubit/shop_setup_cubit.dart';
import 'package:shop_app/features/shop_profile/presentation/shop_field_error_text.dart';
import 'package:shop_app/features/shop_profile/presentation/widgets/shop_logo.dart';
import 'package:shop_app/l10n/gen/app_localizations.dart';

/// Returns a local file path for a picked image, or `null` if cancelled.
typedef PickImage = Future<String?> Function(ImageSource source);

Future<String?> _defaultPickImage(ImageSource source) async {
  final file = await ImagePicker().pickImage(
    source: source,
    maxWidth: 512,
    maxHeight: 512,
    imageQuality: 85,
  );
  return file?.path;
}

/// First-launch setup and, later, "Edit shop profile". Same form.
class ShopSetupPage extends StatelessWidget {
  const ShopSetupPage({
    required this.isEditing,
    this.pickImage = _defaultPickImage,
    super.key,
  });

  final bool isEditing;
  final PickImage pickImage;

  @override
  Widget build(BuildContext context) {
    final profileState = context.read<ShopProfileCubit>().state;
    final initial = profileState is ShopProfileReady
        ? profileState.profile
        : null;
    return BlocProvider(
      create: (context) => ShopSetupCubit(
        context.read<ShopProfileRepository>(),
        initial: initial,
      ),
      child: _ShopSetupView(
        isEditing: isEditing,
        initial: initial,
        pickImage: pickImage,
      ),
    );
  }
}

class _ShopSetupView extends StatefulWidget {
  const _ShopSetupView({
    required this.isEditing,
    required this.initial,
    required this.pickImage,
  });

  final bool isEditing;
  final ShopProfile? initial;
  final PickImage pickImage;

  @override
  State<_ShopSetupView> createState() => _ShopSetupViewState();
}

class _ShopSetupViewState extends State<_ShopSetupView> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _phone = TextEditingController(text: widget.initial?.phone);
  late final _address = TextEditingController(
    text: widget.initial?.addressLine,
  );
  late final _city = TextEditingController(text: widget.initial?.city);
  late final _pincode = TextEditingController(text: widget.initial?.pincode);
  late final _gstin = TextEditingController(text: widget.initial?.gstin);
  late String? _stateCode = widget.initial?.stateCode;
  bool _stateFromGstin = false;

  @override
  void dispose() {
    for (final c in [_name, _phone, _address, _city, _pincode, _gstin]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onGstinChanged(String value) {
    // A valid GSTIN tells us the state, so fill it in for the user.
    if (Gstin.validate(value) == null) {
      setState(() {
        _stateCode = Gstin.stateCode(value);
        _stateFromGstin = true;
      });
    } else if (_stateFromGstin) {
      setState(() => _stateFromGstin = false);
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await context.read<ShopSetupCubit>().save(
      name: _name.text,
      stateCode: _stateCode!,
      phone: _phone.text,
      addressLine: _address.text,
      city: _city.text,
      pincode: _pincode.text,
      gstin: _gstin.text,
    );
  }

  Future<void> _chooseLogo() async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<ShopSetupCubit>();
    final hasLogo = cubit.state.logoPath != null;
    final choice = await showModalBottomSheet<Object>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.logoFromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.logoFromCamera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            if (hasLogo)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l10n.logoRemove),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
          ],
        ),
      ),
    );
    if (choice == 'remove') {
      cubit.removedLogo();
    } else if (choice is ImageSource) {
      final path = await widget.pickImage(choice);
      if (path != null) await cubit.pickedLogo(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String? err(ShopFieldError? e) => e?.message(l10n);

    return BlocListener<ShopSetupCubit, ShopSetupState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        switch (state.status) {
          case SetupStatus.saved:
            messenger.showSnackBar(SnackBar(content: Text(l10n.saved)));
            // First-launch setup: the router moves on to Home by itself.
            if (widget.isEditing && context.canPop()) context.pop();
          case SetupStatus.saveFailed:
            messenger.showSnackBar(SnackBar(content: Text(l10n.saveFailed)));
          case SetupStatus.logoFailed:
            messenger.showSnackBar(SnackBar(content: Text(l10n.logoFailed)));
          case SetupStatus.editing || SetupStatus.saving:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditing ? l10n.editShopTitle : l10n.setupTitle),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (!widget.isEditing) ...[
                Text(l10n.setupIntro),
                const SizedBox(height: 16),
              ],
              Center(
                child: BlocBuilder<ShopSetupCubit, ShopSetupState>(
                  buildWhen: (a, b) => a.logoPath != b.logoPath,
                  builder: (context, state) => Column(
                    children: [
                      ListenableBuilder(
                        listenable: _name,
                        builder: (context, _) => ShopLogo(
                          path: state.logoPath,
                          name: _name.text,
                          radius: 44,
                        ),
                      ),
                      TextButton.icon(
                        key: const Key('logoButton'),
                        onPressed: _chooseLogo,
                        icon: const Icon(Icons.add_a_photo_outlined),
                        label: Text(
                          state.logoPath == null
                              ? l10n.logoAdd
                              : l10n.logoChange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('nameField'),
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: l10n.fieldShopName),
                validator: (v) => err(ShopProfileValidators.name(v)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('phoneField'),
                controller: _phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.fieldPhone,
                  helperText: l10n.optional,
                  prefixText: '+91 ',
                ),
                validator: (v) => err(ShopProfileValidators.phone(v)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('addressField'),
                controller: _address,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                minLines: 1,
                decoration: InputDecoration(
                  labelText: l10n.fieldAddress,
                  helperText: l10n.optional,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      key: const Key('cityField'),
                      controller: _city,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: l10n.fieldCity),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      key: const Key('pincodeField'),
                      controller: _pincode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(labelText: l10n.fieldPincode),
                      validator: (v) => err(ShopProfileValidators.pincode(v)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('gstinField'),
                controller: _gstin,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [LengthLimitingTextInputFormatter(15)],
                onChanged: _onGstinChanged,
                decoration: InputDecoration(
                  labelText: l10n.fieldGstin,
                  helperText: l10n.gstinHelper,
                ),
                validator: (v) =>
                    err(ShopProfileValidators.gstin(v, stateCode: _stateCode)),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                // Re-created when the GSTIN fills in the state.
                key: ValueKey('state-$_stateCode'),
                initialValue: _stateCode,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.fieldState,
                  helperText: _stateFromGstin ? l10n.gstinStateSet : null,
                ),
                items: [
                  for (final s in indianStates)
                    DropdownMenuItem(value: s.code, child: Text(s.name)),
                ],
                onChanged: (code) => setState(() {
                  _stateCode = code;
                  _stateFromGstin = false;
                }),
                validator: (v) => err(ShopProfileValidators.state(v)),
              ),
              const SizedBox(height: 24),
              BlocBuilder<ShopSetupCubit, ShopSetupState>(
                buildWhen: (a, b) => a.status != b.status,
                builder: (context, state) {
                  final saving = state.status == SetupStatus.saving;
                  return FilledButton(
                    key: const Key('saveButton'),
                    onPressed: saving ? null : _submit,
                    child: Text(
                      saving
                          ? l10n.saving
                          : (widget.isEditing
                                ? l10n.save
                                : l10n.saveAndContinue),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
