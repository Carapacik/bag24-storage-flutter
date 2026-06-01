part of 'create_pin_bloc.dart';

@Freezed(copyWith: false)
sealed class CreatePinEvent with _$CreatePinEvent {
  const factory pinChanged(String pin) = _CreatePinChanged;
}
