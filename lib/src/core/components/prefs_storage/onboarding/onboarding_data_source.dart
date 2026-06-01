import 'package:bag24/src/core/utils/persisted_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IOnboardingDataSource() {
  Future<bool?> isHideOnboarding();

  Future<void> setHideOnboarding();

  Future<void> remove();
}

final class OnboardingDataSource({required final SharedPreferencesAsync sharedPreferences})
    implements IOnboardingDataSource {
  late final _hideOnboarding = BoolPreferencesEntry(sharedPreferences: sharedPreferences, key: 'onboarding.hide');

  @override
  Future<bool?> isHideOnboarding() => _hideOnboarding.read();

  @override
  Future<void> setHideOnboarding() => _hideOnboarding.set(true);

  @override
  Future<void> remove() async {
    await _hideOnboarding.remove();
  }
}
