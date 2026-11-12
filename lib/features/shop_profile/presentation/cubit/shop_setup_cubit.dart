import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/core/india/gstin.dart';
import 'package:shop_app/core/india/phone.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';

enum SetupStatus { editing, saving, saved, saveFailed, logoFailed }

class ShopSetupState extends Equatable {
  const ShopSetupState({
    this.logoPath,
    this.status = SetupStatus.editing,
  });

  final String? logoPath;
  final SetupStatus status;

  ShopSetupState copyWith({
    String? Function()? logoPath,
    SetupStatus? status,
  }) => ShopSetupState(
    logoPath: logoPath != null ? logoPath() : this.logoPath,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [logoPath, status];
}

/// The shop setup / edit form. Field validation lives in the form
/// (see `ShopProfileValidators`); this cubit owns the logo and saving.
class ShopSetupCubit extends Cubit<ShopSetupState> {
  ShopSetupCubit(this._repository, {ShopProfile? initial})
    : super(ShopSetupState(logoPath: initial?.logoPath));

  final ShopProfileRepository _repository;

  Future<void> pickedLogo(String sourcePath) async {
    try {
      final stored = await _repository.importLogo(sourcePath);
      emit(state.copyWith(logoPath: () => stored, status: SetupStatus.editing));
    } on Object {
      emit(state.copyWith(status: SetupStatus.logoFailed));
    }
  }

  void removedLogo() => emit(
    state.copyWith(logoPath: () => null, status: SetupStatus.editing),
  );

  /// Saves already-validated form values, normalizing what people type.
  Future<void> save({
    required String name,
    required String stateCode,
    String? phone,
    String? addressLine,
    String? city,
    String? pincode,
    String? gstin,
  }) async {
    if (state.status == SetupStatus.saving) return;
    emit(state.copyWith(status: SetupStatus.saving));
    try {
      await _repository.save(
        ShopProfile(
          name: name.trim(),
          stateCode: stateCode,
          phone: _orNull(phone, IndianPhone.normalize),
          addressLine: addressLine,
          city: city,
          pincode: pincode?.trim(),
          gstin: _orNull(gstin, Gstin.normalize),
          logoPath: state.logoPath,
        ),
      );
      emit(state.copyWith(status: SetupStatus.saved));
    } on Object {
      emit(state.copyWith(status: SetupStatus.saveFailed));
    }
  }

  static String? _orNull(String? v, String Function(String) normalize) =>
      (v == null || v.trim().isEmpty) ? null : normalize(v);
}
