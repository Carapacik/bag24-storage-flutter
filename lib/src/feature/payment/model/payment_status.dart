import 'package:rest_client/order/dto/payment_state_dto.dart';

/// Локальный enum для статуса платежа, маппится из PaymentState из rest_client
enum PaymentStatus {
  created,
  inProgress,
  succeeded,
  failed,
  unknown;

  factory fromPaymentState(PaymentStateDto state) {
    return switch (state) {
      PaymentStateDto.created => PaymentStatus.created,
      PaymentStateDto.inProgress => PaymentStatus.inProgress,
      PaymentStateDto.succeeded => PaymentStatus.succeeded,
      PaymentStateDto.failed => PaymentStatus.failed,
      PaymentStateDto.$unknown => PaymentStatus.unknown,
    };
  }
}
