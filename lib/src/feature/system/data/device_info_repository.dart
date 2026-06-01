import 'dart:io';

import 'package:bag24/src/feature/system/model/device_type.dart';
import 'package:device_info_plus/device_info_plus.dart';

abstract interface class IDeviceInfoRepository() {
  Future<({String deviceId, DeviceType deviceType, String osVersion})> get deviceInfo;
}

class const DeviceInfoRepository() implements IDeviceInfoRepository {
  @override
  Future<({String deviceId, DeviceType deviceType, String osVersion})> get deviceInfo async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return (deviceId: androidInfo.id, deviceType: DeviceType.android, osVersion: androidInfo.version.release);
    } else {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return (
        deviceId: iosInfo.identifierForVendor ?? '${iosInfo.systemName}${iosInfo.model}${iosInfo.name}',
        deviceType: DeviceType.ios,
        osVersion: iosInfo.systemVersion,
      );
    }
  }
}
