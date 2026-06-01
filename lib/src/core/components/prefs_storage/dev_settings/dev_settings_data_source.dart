import 'package:bag24/src/core/components/prefs_storage/dev_settings/dao/dev_settings_dao.dart';
import 'package:bag24/src/core/utils/persisted_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IDevSettingsDataSource() {
  Future<DevSettingsDao?> get devSettings;

  Future<void> setServer(String server);

  Future<void> setPort(String port);

  Future<void> toggleProxyEnabled();

  Future<void> removeAll();
}

final class DevSettingsDataSource({required final SharedPreferencesAsync sharedPreferences})
    implements IDevSettingsDataSource {
  late final _server = StringPreferencesEntry(sharedPreferences: sharedPreferences, key: 'dev_settings_server');
  late final _port = StringPreferencesEntry(sharedPreferences: sharedPreferences, key: 'dev_settings_port');
  late final _proxyEnabled = BoolPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: 'dev_settings_proxy_enabled',
  );

  @override
  Future<void> removeAll() async {
    await _server.remove();
    await _port.remove();
    await _proxyEnabled.remove();
  }

  @override
  Future<DevSettingsDao?> get devSettings async => DevSettingsDao(
    server: (await _server.read()) ?? '',
    port: (await _port.read()) ?? '',
    proxyEnabled: (await _proxyEnabled.read()) ?? false,
  );

  @override
  Future<void> setServer(String server) => _server.setIfNullRemove(server);

  @override
  Future<void> setPort(String port) => _port.setIfNullRemove(port);

  @override
  Future<void> toggleProxyEnabled() => _proxyEnabled.setIfNullRemove(true);
}
