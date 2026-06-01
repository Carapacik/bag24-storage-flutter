import 'dart:async';

import 'package:bag24/src/core/components/prefs_storage/permissions/permissions_data_source.dart';
import 'package:permission_handler/permission_handler.dart';

abstract interface class IPermissionsRepository() {
  Future<bool> checkLocationPermission();

  Future<bool?> get isLocationEnabled;

  Future<bool> get isLocationGranted;

  Future<bool?> get isNotificationEnabled;

  Future<bool> get isNotificationGranted;

  Future<void> setLocation({required bool location});

  Future<void> setNotification({required bool notification});

  Future<void> checkAllPermissions();
}

final class const PermissionsRepository({required final IPermissionsDataSource _permissionsDataSource})
    implements IPermissionsRepository {
  @override
  Future<bool> checkLocationPermission() async {
    final bool isLocationServiceStatus = await Permission.location.serviceStatus.isEnabled;
    final bool isLocationWhenInUseServiceStatus = await Permission.locationWhenInUse.serviceStatus.isEnabled;
    final bool isEnabled = isLocationServiceStatus && isLocationWhenInUseServiceStatus;

    if (isEnabled) {
      final bool isLocationGranted = await Permission.location.isGranted;
      if (isLocationGranted) {
        await _permissionsDataSource.setLocation(location: true);
        return true;
      }
    }
    await _permissionsDataSource.setLocation(location: false);
    return false;
  }

  @override
  Future<bool?> get isLocationEnabled async => await _permissionsDataSource.getLocation();

  @override
  Future<bool> get isLocationGranted async => await Permission.location.isGranted;

  @override
  Future<bool?> get isNotificationEnabled async => await _permissionsDataSource.getNotification();

  @override
  Future<bool> get isNotificationGranted async => await Permission.notification.request().isGranted;

  @override
  Future<void> setLocation({required bool location}) => _permissionsDataSource.setLocation(location: location);

  @override
  Future<void> setNotification({required bool notification}) =>
      _permissionsDataSource.setNotification(notification: notification);

  @override
  Future<void> checkAllPermissions() async {
    await checkLocationPermission();
    await _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    if (await Permission.notification.status.isGranted) {
      await _permissionsDataSource.setNotification(notification: true);
    } else {
      await _permissionsDataSource.setNotification(notification: false);
    }
  }
}
