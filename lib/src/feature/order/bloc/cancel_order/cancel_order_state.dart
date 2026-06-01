part of 'cancel_order_bloc.dart';

@Freezed()
sealed class const CancelOrderState._() with _$CancelOrderState {
  const factory idle() = _CancelOrderIdle;

  const factory processing() = _CancelOrderProcessing;

  const factory success() = _CancelOrderSuccess;

  const factory failure({required AppException exception}) = _CancelOrdereFailure;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);
}
