import 'package:bag24/src/core/components/prefs_storage/onboarding/onboarding_data_source.dart';

abstract interface class IOnboardingRepository() {
  Future<void> setHideOnboarding();

  Future<bool> isHideOnboarding();
}

class const OnboardingRepository({required final IOnboardingDataSource _onboardingDataSource})
    implements IOnboardingRepository {
  @override
  Future<void> setHideOnboarding() => _onboardingDataSource.setHideOnboarding();

  @override
  Future<bool> isHideOnboarding() => _onboardingDataSource.isHideOnboarding().then((value) => value ?? false);
}
