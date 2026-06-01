import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/support/data/mail_repository.dart';
import 'package:bag24/src/feature/support/model/contact_support_data.dart';
import 'package:bag24/src/feature/system/data/device_info_repository.dart';
import 'package:bag24/src/feature/system/model/device_type.dart';
import 'package:bag24/src/feature/user/data/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'contact_support_bloc.freezed.dart';
part 'contact_support_event.dart';
part 'contact_support_state.dart';

final class ContactSupportBloc({
  required final IDeviceInfoRepository _deviceInfoRepository,
  required final PackageInfo _packageInfo,
  required final IUserRepository _userRepository,
  required final IMailRepository _mailRepository,
}) extends Bloc<ContactSupportEvent, ContactSupportState> {
  this : super(const ContactSupportState.idle()) {
    on<_ContactSupportSend>(_send);
  }

  Future<void> _send(_ContactSupportSend event, Emitter<ContactSupportState> emitter) async {
    emitter(const ContactSupportState.processing());
    await ExceptionHandler.handle(
      () async {
        final String phoneNumber = await _userRepository.getLocalUser().then((u) => u?.phoneNumber ?? 'null');
        final ({String deviceId, DeviceType deviceType, String osVersion}) deviceInfo =
            await _deviceInfoRepository.deviceInfo;
        final String appVersion = _packageInfo.version;
        final subject = '[${event.data.airport} ${event.data.service}] ${event.data.topic}';
        final text =
            '${event.data.comment}<br>'
            '<br>Phone Number: $phoneNumber'
            '<br>${'_' * 30}<br>'
            '<br>App Version: $appVersion'
            '<br>Device Info: $deviceInfo';

        await _mailRepository.sendMessage(subject: subject, text: text);
        emitter(const ContactSupportState.success());
      },
      onError: (exception, stackTrace) {
        emitter(ContactSupportState.failure(exception: exception));
      },
      onDone: () {
        emitter(const ContactSupportState.idle());
      },
    );
  }
}
