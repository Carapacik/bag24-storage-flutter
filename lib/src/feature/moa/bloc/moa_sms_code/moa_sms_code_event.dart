part of 'moa_sms_code_bloc.dart';

@Freezed(copyWith: false)
sealed class MOASmsCodeEvent with _$MOASmsCodeEvent {
  const factory send(String code) = _MOASmsCodeEventSend;

  const factory resend() = _MOASmsCodeEventResend;
}
