part of 'transfer_order_bloc.dart';

@Freezed()
sealed class const TransferOrderState._() with _$TransferOrderState {
  const factory idle(String qr) = _TransferOrderIdle;

  const factory processing(String qr) = _TransferOrderProcessing;

  const factory success(String qr) = _TransferOrderSuccess;

  const factory failure(String qr, {required AppException exception}) = _TransferOrdereFailure;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);
}
