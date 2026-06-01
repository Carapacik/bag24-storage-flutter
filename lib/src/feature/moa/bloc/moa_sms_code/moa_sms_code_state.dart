part of 'moa_sms_code_bloc.dart';

@Freezed()
sealed class const MOASmsCodeState._() with _$MOASmsCodeState {
  const factory idle() = _MOASmsCodeStateIdle;

  const factory processing() = _MOASmsCodeStateProcessing;

  const factory success() = _MOASmsCodeStateSuccess;

  const factory failure({required AppException exception}) = _MOASmsCodeStateFailure;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);
}
