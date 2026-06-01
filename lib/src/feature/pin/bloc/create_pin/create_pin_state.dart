part of 'create_pin_bloc.dart';

@Freezed(copyWith: true)
sealed class const CreatePinState._() with _$CreatePinState {
  const factory idle({required String pin, String? savedPin}) = _CreatePinIdle;

  const factory processing({required String pin, String? savedPin}) = _CreatePinProcessing;

  const factory success({required List<BiometricType> availableBiometrics, required String pin, String? savedPin}) =
      _CreatePinSuccess;

  const factory failure({required String pin, String? savedPin}) = _CreatePinFailure;

  bool get isFailure => maybeMap(failure: (_) => true, orElse: () => false);
}
