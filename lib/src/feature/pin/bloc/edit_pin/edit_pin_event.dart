part of 'edit_pin_bloc.dart';

@Freezed(copyWith: false)
sealed class EditPinEvent with _$EditPinEvent {
  const factory pinChanged(String pin) = _EditPinChanged;
}
