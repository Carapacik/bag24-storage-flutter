import 'package:bag24/src/core/components/prefs_storage/biometrics/biometrics_data_source.dart';
import 'package:bag24/src/core/components/prefs_storage/dev_settings/dev_settings_data_source.dart';
import 'package:bag24/src/core/components/prefs_storage/moa/moa_data_source.dart';
import 'package:bag24/src/core/components/prefs_storage/onboarding/onboarding_data_source.dart';
import 'package:bag24/src/core/components/prefs_storage/permissions/permissions_data_source.dart';
import 'package:bag24/src/core/components/prefs_storage/photo_rules/photo_rules_data_source.dart';
import 'package:bag24/src/core/components/prefs_storage/user/user_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class PrefsStorage({required final SharedPreferencesAsync _sharedPreferences}) {
  IBiometricsDataSource? _biometricsDataSource;
  IMOADataSource? _moaDataSource;
  IOnboardingDataSource? _onboardingDataSource;
  IPermissionsDataSource? _permissionsDataSource;
  IPhotoRulesDataSource? _photoRulesDataSource;
  IUserDataSource? _userDataSource;

  IDevSettingsDataSource? _devSettingsDataSource;

  IBiometricsDataSource get biometricsDataSource =>
      _biometricsDataSource ??= BiometricsDataSource(sharedPreferences: _sharedPreferences);

  IMOADataSource get moaDataSource => _moaDataSource ??= MOADataSource(sharedPreferences: _sharedPreferences);

  IOnboardingDataSource get onboardingDataSource =>
      _onboardingDataSource ??= OnboardingDataSource(sharedPreferences: _sharedPreferences);

  IPermissionsDataSource get permissionsDataSource =>
      _permissionsDataSource ??= PermissionsDataSource(sharedPreferences: _sharedPreferences);

  IPhotoRulesDataSource get photoRulesDataSource =>
      _photoRulesDataSource ??= PhotoRulesDataSource(sharedPreferences: _sharedPreferences);

  IUserDataSource get userDataSource => _userDataSource ??= UserDataSource(sharedPreferences: _sharedPreferences);

  IDevSettingsDataSource get devSettingsDataSource =>
      _devSettingsDataSource ??= DevSettingsDataSource(sharedPreferences: _sharedPreferences);

  Future<void> remove() async {
    await [
      biometricsDataSource.remove(),
      moaDataSource.remove(),
      permissionsDataSource.remove(),
      photoRulesDataSource.remove(),
      userDataSource.remove(),
    ].wait;
  }
}
