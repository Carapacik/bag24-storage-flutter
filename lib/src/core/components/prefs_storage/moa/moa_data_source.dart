import 'package:bag24/src/core/utils/persisted_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IMOADataSource() {
  Future<int?> getMiles();

  Future<void> setMiles(int miles);

  Future<void> remove();
}

final class MOADataSource({required final SharedPreferencesAsync sharedPreferences}) implements IMOADataSource {
  late final _miles = IntPreferencesEntry(sharedPreferences: sharedPreferences, key: 'moa.miles');

  @override
  Future<int?> getMiles() => _miles.read();

  @override
  Future<void> setMiles(int miles) => _miles.set(miles);

  @override
  Future<void> remove() async {
    await _miles.remove();
  }
}
