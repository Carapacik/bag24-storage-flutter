// ignore_for_file: avoid_positional_boolean_parameters
import 'package:bag24/src/core/components/prefs_storage/biometrics/biometrics_data_source.dart';
import 'package:bag24/src/core/constant/localization/generated/l10n.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

abstract interface class IBiometricsRepository() {
  Future<bool> hasBiometrics();

  Future<bool> getFace();

  Future<bool> getFingerprint();

  Future<bool> getStrong();

  Future<void> setFace({required bool face});

  Future<void> setFingerprint({required bool fingerprint});

  Future<void> setStrong({required bool strong});

  Future<void> localAuthenticate(
    BuildContext context, {
    required void Function(bool) onAuthenticate,
    bool checkForSavedBiometrics = false,
  });
}

class const BiometricsRepository({
  required final IBiometricsDataSource _biometricsDataSource,
  required final LocalAuthentication _localAuthentication,
}) implements IBiometricsRepository {
  @override
  Future<void> setFace({required bool face}) => _biometricsDataSource.setFace(face: face);

  @override
  Future<void> setFingerprint({required bool fingerprint}) =>
      _biometricsDataSource.setFingerprint(fingerprint: fingerprint);

  @override
  Future<void> setStrong({required bool strong}) => _biometricsDataSource.setStrong(strong: strong);

  @override
  Future<bool> hasBiometrics() async => (await getFace()) || (await getFingerprint()) || (await getStrong());

  @override
  Future<bool> getFace() async => (await _biometricsDataSource.getFace()) ?? false;

  @override
  Future<bool> getFingerprint() async => (await _biometricsDataSource.getFingerprint()) ?? false;

  @override
  Future<bool> getStrong() async => (await _biometricsDataSource.getStrong()) ?? false;

  @override
  Future<void> localAuthenticate(
    BuildContext context, {
    required void Function(bool) onAuthenticate,
    bool checkForSavedBiometrics = false,
  }) async {
    final AppLocalizations l10n = context.l10n;
    var canCheckBiometrics = false;
    var isDeviceSupported = false;
    try {
      canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      isDeviceSupported = await _localAuthentication.isDeviceSupported();
    } on Object {
      canCheckBiometrics = false;
    }
    if (!canCheckBiometrics && !isDeviceSupported) {
      return;
    }
    if (checkForSavedBiometrics) {
      final bool hasSavedBiometrics = await hasBiometrics();
      if (!hasSavedBiometrics) {
        return;
      }
    }
    return await _localAuthentication
        .authenticate(
          localizedReason: l10n.allowAppUseBiometricsAuthentication,
          authMessages: [
            AndroidAuthMessages(
              signInTitle: l10n.biometricsTitle,
              cancelButton: l10n.cancel,
              signInHint: l10n.biometricHint,
            ),
            IOSAuthMessages(cancelButton: l10n.cancel, localizedFallbackTitle: l10n.biometricsTitle),
          ],
          biometricOnly: true,
        )
        .then(onAuthenticate);
  }
}
