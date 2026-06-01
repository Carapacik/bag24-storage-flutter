import 'package:bag24/src/core/utils/persisted_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IPhotoRulesDataSource() {
  Future<bool?> getPhotoRules();

  Future<void> setPhotoRules({required bool isPhotoRulesShown});

  Future<void> remove();
}

final class PhotoRulesDataSource({required final SharedPreferencesAsync sharedPreferences})
    implements IPhotoRulesDataSource {
  late final _photoRulesShown = BoolPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: 'luggage.photo_rules.shown',
  );

  @override
  Future<bool?> getPhotoRules() async => await _photoRulesShown.read();

  @override
  Future<void> setPhotoRules({required bool isPhotoRulesShown}) => _photoRulesShown.set(isPhotoRulesShown);

  @override
  Future<void> remove() async {
    await _photoRulesShown.remove();
  }
}
