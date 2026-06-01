import 'package:bag24/src/core/constant/localization/localization.dart';
import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/feature/authentication/data/authentication_repository.dart';
import 'package:bag24/src/feature/authentication/model/app_device_info.dart';
import 'package:bag24/src/feature/authentication/model/input_phone_data.dart';
import 'package:bag24/src/feature/pin/data/pin_repository.dart';
import 'package:bag24/src/feature/system/data/device_info_repository.dart';
import 'package:bag24/src/feature/system/model/device_type.dart';
import 'package:bag24/src/feature/user/data/user_repository.dart';
import 'package:bag24/src/feature/user/model/user_profile.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:push_notification_interface/push_interface.dart';
import 'package:rest_client/user/dto/user_dto.dart';

part 'otp_code_bloc.freezed.dart';
part 'otp_code_event.dart';
part 'otp_code_state.dart';

final class OtpCodeBloc({
  required final String _phone,
  required final IAuthenticationRepository _authenticationRepository,
  required final IPinRepository _pinRepository,
  required final IPushNotificationService _pushNotificationService,
  required final IDeviceInfoRepository _deviceInfoRepository,
  required final PackageInfo _packageInfo,
  required final IUserRepository _userRepository,
}) extends Bloc<OtpCodeEvent, OtpCodeState> {
  this : super(const OtpCodeState.idle()) {
    on<_OtpCodeVerifyPressed>(_verifyPressed);
    on<_OtpCodeResent>(_resend);
  }

  Future<void> _verifyPressed(_OtpCodeVerifyPressed event, Emitter<OtpCodeState> emitter) async {
    emitter(const OtpCodeState.processing());
    await ExceptionHandler.handle(
      () async {
        final String appVersion = _packageInfo.version;
        final ({String deviceId, DeviceType deviceType, String osVersion}) deviceInfo =
            await _deviceInfoRepository.deviceInfo;
        final String? pushToken = await _pushNotificationService.getToken();
        await _authenticationRepository.signIn(
          _phone,
          event.code,
          AppDeviceInfo(
            appVersion: appVersion,
            deviceId: deviceInfo.deviceId,
            type: deviceInfo.deviceType.json,
            osVersion: deviceInfo.osVersion,
            locale: Localization.computeDefaultLocale().toString(),
            screenResolution: event.screenResolution,
            pushToken: pushToken,
          ),
        );
        final UserProfile? profile = await _userRepository.me();
        if (profile == null) {
          return;
        }
        if (profile.status == UserStatus.init) {
          await _userRepository.register();
          await _authenticationRepository.refreshUser();

          await _userRepository.registerUserAgreements(privacyPolicy: true, userAgreement: true, companyRules: true);

          await _authenticationRepository.refreshUser();
          await _userRepository.me();
        }
        final Routes route = await _routeByStatus(profile.status);
        emitter(OtpCodeState.success(route: route));
      },
      onError: (exception, stackTrace) {
        emitter(OtpCodeState.failure(exception: exception));
      },
      onDone: () {
        emitter(const OtpCodeState.idle());
      },
    );
  }

  Future<void> _resend(_OtpCodeResent event, Emitter<OtpCodeState> emitter) =>
      _authenticationRepository.initPhone(_phone, SignInType.sms);

  Future<Routes> _routeByStatus(UserStatus userStatus) async {
    switch (userStatus) {
      case UserStatus.init:
      case UserStatus.registered:
        final String? pin = await _pinRepository.getPin();
        if (pin == null || pin.isEmpty) {
          return Routes.createPin;
        } else {
          return Routes.home;
        }
      case UserStatus.active:
        return Routes.createPin;
      case UserStatus.deleted:
        return Routes.signIn;
    }
  }
}
