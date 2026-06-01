part of 'payment_bloc.dart';

@freezed
sealed class const PaymentState._() with _$PaymentState {
  const factory idle({String? paymentId}) = _PaymentStateIdle;

  const factory processing({String? paymentId}) = _PaymentStateProcessing;

  const factory success({
    required String orderId,
    required List<String> luggageIds,
    required OrderStatus orderStatus,
    required PaymentStatus paymentStatus,
    String? paymentUrl,
    String? paymentId,
  }) = _PaymentStateSuccess;

  const factory failure({required AppException exception, String? paymentId}) = _PaymentStateFailure;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);
}
