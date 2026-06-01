part of 'order_receipts_bloc.dart';

@Freezed(copyWith: false)
sealed class OrderReceiptsEvent with _$OrderReceiptsEvent {
  const factory start(String orderId) = _OrderReceiptsStarted;
}
