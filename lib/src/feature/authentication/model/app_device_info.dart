import 'package:rest_client/account/dto/verify_request_body_dto.dart';

class const AppDeviceInfo({
  required final String deviceId,
  required final String type,
  required final String osVersion,
  required final String appVersion,
  required final String locale,
  required final String screenResolution,
  required final String? pushToken,
}) {
  static VerifyDevice encode(AppDeviceInfo data) => VerifyDevice(
    deviceId: data.deviceId,
    type: data.type,
    osVersion: data.osVersion,
    appVersion: data.appVersion,
    locale: data.locale,
    screenResolution: data.screenResolution,
    fcmToken: data.pushToken,
  );

  @override
  String toString() =>
      'AppDeviceInfo(deviceId: $deviceId, type: $type, osVersion: $osVersion, appVersion: $appVersion, locale: $locale, screenResolution: $screenResolution, pushToken: $pushToken)';
}
