part of 'cancel_order_bloc.dart';

@Freezed(copyWith: false)
sealed class CancelOrderEvent with _$CancelOrderEvent {
  const factory cancel() = _CancelOrderCancel;

  const factory refund() = _CancelOrderRefund;
}
