import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';

sealed class ShopProfileState extends Equatable {
  const ShopProfileState();

  @override
  List<Object?> get props => [];
}

final class ShopProfileLoading extends ShopProfileState {
  const ShopProfileLoading();
}

/// First launch: no shop set up yet.
final class ShopProfileMissing extends ShopProfileState {
  const ShopProfileMissing();
}

final class ShopProfileReady extends ShopProfileState {
  const ShopProfileReady(this.profile);

  final ShopProfile profile;

  @override
  List<Object?> get props => [profile];
}

/// App-wide view of the shop profile. Follows the database, so any edit
/// shows up everywhere immediately. Also drives first-launch routing.
class ShopProfileCubit extends Cubit<ShopProfileState> {
  ShopProfileCubit(ShopProfileRepository repository)
    : super(const ShopProfileLoading()) {
    _subscription = repository.watch().listen(
      (profile) => emit(
        profile == null
            ? const ShopProfileMissing()
            : ShopProfileReady(profile),
      ),
    );
  }

  late final StreamSubscription<ShopProfile?> _subscription;

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await super.close();
  }
}
