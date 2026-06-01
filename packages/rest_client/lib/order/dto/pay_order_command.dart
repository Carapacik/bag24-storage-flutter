import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/order/dto/payment_method.dart';

part 'pay_order_command.g.dart';

@JsonSerializable()
class const PayOrderCommand({
  /// Платежный метод
  required final PaymentMethodDto paymentMethod,

  /// Идентификаторы платежей (только для доплаты)
  required final List<String> luggageIds,

  /// Сумма в милях к списанию
  final int? miles,
}) {
  factory fromJson(Map<String, Object?> json) => _$PayOrderCommandFromJson(json);

  Map<String, Object?> toJson() => _$PayOrderCommandToJson(this);
}
