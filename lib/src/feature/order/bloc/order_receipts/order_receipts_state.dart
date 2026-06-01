part of 'order_receipts_bloc.dart';

@Freezed()
sealed class const OrderReceiptsState._() with _$OrderReceiptsState {
  const factory idle() = _OrderReceiptsIdle;

  const factory processing() = _OrderReceiptsProcessing;

  const factory success(List<Receipt> receipts) = _OrderReceiptsSuccess;

  const factory failure({required AppException exception}) = _OrderReceiptseFailure;
}
