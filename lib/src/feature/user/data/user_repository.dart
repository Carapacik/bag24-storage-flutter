import 'dart:async';

import 'package:bag24/src/core/components/prefs_storage/user/dao/user_dao.dart';
import 'package:bag24/src/core/components/prefs_storage/user/user_data_source.dart';
import 'package:bag24/src/feature/user/model/user_profile.dart';
import 'package:rest_client/user/user_client.dart';

abstract interface class IUserRepository() {
  Future<UserProfile?> me();

  Future<UserProfile?> update({required String firstName, required String lastName, required String phoneNumber});

  Future<UserProfile?> register();

  Future<void> registerUserAgreements({
    required bool userAgreement,
    required bool privacyPolicy,
    required bool companyRules,
  });

  Future<UserProfile?> getLocalUser();

  Future<void> setLocalUser(UserProfile user);

  Future<void> removeLocalUser();

  Future<void> deleteAccount();
}

class const UserRepository({required final UserClient _userClient, required final IUserDataSource _userDataSource})
    implements IUserRepository {
  @override
  Future<UserProfile?> me() async {
    final UserProfile user = await _userClient.me().then((dto) => UserProfile.decode(dto.result));
    await _userDataSource.setUserData(UserProfile.encodeDao(user));
    return user;
  }

  @override
  Future<UserProfile?> update({required String firstName, required String lastName, required String phoneNumber}) =>
      _userClient
          .update(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
          .then((d) => UserProfile.decode(d.result.user));

  @override
  Future<UserProfile?> register() async {
    final UserProfile user = await _userClient.register().then((dto) => UserProfile.decode(dto.result));
    await setLocalUser(user);

    return user;
  }

  @override
  Future<void> registerUserAgreements({
    required bool userAgreement,
    required bool privacyPolicy,
    required bool companyRules,
  }) async => await _userClient.registerUserAgreements(
    userAgreement: userAgreement,
    privacyPolicy: privacyPolicy,
    companyRules: companyRules,
  );

  @override
  Future<UserProfile?> getLocalUser() async {
    try {
      final UserDao? currentUser = await _userDataSource.getUserData();
      return currentUser == null ? null : UserProfile.decodeDao(currentUser);
    } on Object {
      return null;
    }
  }

  @override
  Future<void> setLocalUser(UserProfile user) => _userDataSource.setUserData(UserProfile.encodeDao(user));

  @override
  Future<void> removeLocalUser() => _userDataSource.remove();

  @override
  Future<void> deleteAccount() => _userClient.deleteAccount();
}
