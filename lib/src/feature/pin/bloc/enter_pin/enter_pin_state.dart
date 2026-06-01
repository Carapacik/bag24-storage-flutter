part of 'enter_pin_bloc.dart';

@Freezed()
sealed class const EnterPinState._() with _$EnterPinState {
  const factory idle({required String pin}) = _EnterPinIdle;

  const factory processing({required String pin}) = _EnterPinProcessing;

  const factory success({required String pin}) = _EnterPinSuccess;

  const factory failure({required String pin}) = _EnterPinFailure;

  bool get isFailure => maybeMap(failure: (_) => true, orElse: () => false);
}
