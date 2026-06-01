part of 'moa_bloc.dart';

@Freezed(copyWith: false)
sealed class MOAEvent with _$MOAEvent {
  const factory start() = _MOAEventStart;

  const factory register() = _MOAEventRegister;
}
