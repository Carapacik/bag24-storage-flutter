part of 'payment_bloc.dart';

@Freezed(copyWith: false)
sealed class PaymentEvent with _$PaymentEvent {
  const factory processPayment({
    required PaymentMethodType paymentMethodType,
    BindingResult? bindingResult,
    String? bindingId,
    int? milesToUse,
  }) = _PaymentEventProcessPayment;

  const factory cancelPayment() = _PaymentEventCancelPayment;

  const factory checkPaymentStatus() = _PaymentEventCheckPaymentStatus;
}
