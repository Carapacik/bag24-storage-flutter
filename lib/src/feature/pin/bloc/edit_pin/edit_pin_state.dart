part of 'edit_pin_bloc.dart';

@Freezed()
sealed class const EditPinState._() with _$EditPinState {
  const factory idle({required EditPinType type, required String pin, String? savedPin}) = _EditPinIdle;

  const factory success({required EditPinType type, required String pin, String? savedPin}) = _EditPinSuccess;

  const factory failure({required EditPinType type, required String pin, String? savedPin}) = _EditPinFailure;

  bool get isFailure => maybeMap(failure: (_) => true, orElse: () => false);
}
