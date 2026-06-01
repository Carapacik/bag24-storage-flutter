part of 'check_in_luggage_bloc.dart';

@Freezed()
sealed class const CheckInLuggageState._() with _$CheckInLuggageState {
  const factory idle(Storage? storage, {required bool isShownPhotoRules}) = _CheckInLuggageStateIdle;

  const factory processing(Storage? storage, {required bool isShownPhotoRules}) = _CheckInLuggageStateProcessing;

  const factory success(Storage? storage, {required bool isShownPhotoRules, required String orderId}) =
      _CheckInLuggageStateSuccess;

  const factory failure(Storage? storage, {required bool isShownPhotoRules, required AppException exception}) =
      _CheckInLuggageStateFailure;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);
}
