part of 'enter_pin_bloc.dart';

@Freezed(copyWith: false)
sealed class EnterPinEvent with _$EnterPinEvent {
  const factory pinChanged(String pin) = _EnterPinChanged;
}
