part of 'transfer_order_bloc.dart';

@Freezed(copyWith: false)
sealed class TransferOrderEvent with _$TransferOrderEvent {
  const factory start(String orderId, OrderStatus orderStatus, List<String> luggageIds) = _TransferOrderStarted;
}
