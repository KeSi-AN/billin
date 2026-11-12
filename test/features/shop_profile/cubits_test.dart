import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile.dart';
import 'package:shop_app/features/shop_profile/domain/shop_profile_repository.dart';
import 'package:shop_app/features/shop_profile/presentation/cubit/shop_profile_cubit.dart';
import 'package:shop_app/features/shop_profile/presentation/cubit/shop_setup_cubit.dart';

class MockRepo extends Mock implements ShopProfileRepository;

void main() {
  setUpAll(() => registerFallbackValue(const ShopProfile(name: 'x', stateCode: '27')));

  late MockRepo repo;
  setUp(() => repo = MockRepo());

  group('ShopProfileCubit', () {
    const profile = ShopProfile(name: 'Shop', stateCode: '27');

    blocTest<ShopProfileCubit, ShopProfileState>(
      'follows the repository: missing, then ready',
      setUp: () => when(repo.watch).thenAnswer(
        (_) => Stream.fromIterable([null, profile]),
      ),
      build: () => ShopProfileCubit(repo),
      expect: () => const [ShopProfileMissing(), ShopProfileReady(profile)],
    );
  });

  group('ShopSetupCubit', () {
    blocTest<ShopSetupCubit, ShopSetupState>(
      'normalizes phone and GSTIN before saving',
      setUp: () => when(() => repo.save(any())).thenAnswer((_) async {}),
      build: () => ShopSetupCubit(repo),
      act: (c) => c.save(
        name: ' My Shop ',
        stateCode: '27',
        phone: '+91 98765 43210',
        gstin: ' 27aapfu0939f1zv ',
        addressLine: '',
      ),
      expect: () => const [
        ShopSetupState(status: SetupStatus.saving),
        ShopSetupState(status: SetupStatus.saved),
      ],
      verify: (_) {
        final saved =
            verify(() => repo.save(captureAny())).captured.single as ShopProfile;
        expect(saved.name, 'My Shop');
        expect(saved.phone, '9876543210');
        expect(saved.gstin, '27AAPFU0939F1ZV');
      },
    );

    blocTest<ShopSetupCubit, ShopSetupState>(
      'reports a failed save',
      setUp: () =>
          when(() => repo.save(any())).thenThrow(Exception('disk full')),
      build: () => ShopSetupCubit(repo),
      act: (c) => c.save(name: 'A', stateCode: '27'),
      expect: () => const [
        ShopSetupState(status: SetupStatus.saving),
        ShopSetupState(status: SetupStatus.saveFailed),
      ],
    );

    blocTest<ShopSetupCubit, ShopSetupState>(
      'stores a picked logo, and can remove it',
      setUp: () => when(() => repo.importLogo('/tmp/pick.png'))
          .thenAnswer((_) async => '/app/logos/logo_1.png'),
      build: () => ShopSetupCubit(repo),
      act: (c) async {
        await c.pickedLogo('/tmp/pick.png');
        c.removedLogo();
      },
      expect: () => const [
        ShopSetupState(logoPath: '/app/logos/logo_1.png'),
        ShopSetupState(),
      ],
    );
  });
}
