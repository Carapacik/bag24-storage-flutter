import 'dart:convert' show json;

import 'package:bag24/src/core/components/prefs_storage/user/dao/user_dao.dart';
import 'package:bag24/src/core/utils/persisted_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IUserDataSource() {
  Future<UserDao?> getUserData();

  Future<void> setUserData(UserDao user);

  Future<void> remove();
}

final class UserDataSource({required final SharedPreferencesAsync sharedPreferences}) implements IUserDataSource {
  late final _userData = StringPreferencesEntry(sharedPreferences: sharedPreferences, key: 'user.data');

  @override
  Future<UserDao?> getUserData() async {
    final String? user = await _userData.read();
    return user == null ? null : UserDao.fromJson(json.decode(user) as Map<String, dynamic>);
  }

  @override
  Future<void> setUserData(UserDao user) => _userData.set(json.encode(user.toJson()));

  @override
  Future<void> remove() async {
    await _userData.remove();
  }
}
