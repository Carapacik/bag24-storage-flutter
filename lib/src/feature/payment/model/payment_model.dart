import 'package:bag24/src/feature/payment/model/payment_status.dart';
import 'package:meta/meta.dart';

@immutable
class const PaymentModel({
  /// Идентификатор платежа
  required final String id,

  /// Сумма платежа (в минимальных единицах валюты)
  required final int amount,

  /// Состояние платежа
  required final PaymentStatus status,

  /// Дата создания платежа
  required final DateTime createdAt,

  /// Ссылка на платеж
  final String? url,
}) {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amount == other.amount &&
          status == other.status &&
          createdAt == other.createdAt &&
          url == other.url;

  @override
  int get hashCode => id.hashCode ^ amount.hashCode ^ status.hashCode ^ createdAt.hashCode ^ url.hashCode;
}
