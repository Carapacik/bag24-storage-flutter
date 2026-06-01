import 'package:bag24/src/core/utils/persisted_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IPermissionsDataSource() {
  Future<bool?> getLocation();

  Future<bool?> getNotification();

  Future<void> setLocation({required bool location});

  Future<void> setNotification({required bool notification});

  Future<void> remove();
}

final class PermissionsDataSource({required final SharedPreferencesAsync sharedPreferences})
    implements IPermissionsDataSource {
  late final _location = BoolPreferencesEntry(sharedPreferences: sharedPreferences, key: 'permission.location');
  late final _notification = BoolPreferencesEntry(sharedPreferences: sharedPreferences, key: 'permission.notification');

  @override
  Future<bool?> getLocation() => _location.read();

  @override
  Future<bool?> getNotification() => _notification.read();

  @override
  Future<void> setLocation({required bool location}) => _location.set(location);

  @override
  Future<void> setNotification({required bool notification}) => _notification.set(notification);

  @override
  Future<void> remove() async {
    await [_location.remove(), _notification.remove()].wait;
  }
}
