import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/order/dto/payment_state_dto.dart';

part 'payment_data_dto.g.dart';

@JsonSerializable()
class const PaymentDataDto({
  /// Идентификатор платежа
  required final String id,

  /// Сумма платежа (в минимальных единицах валюты)
  required final int amount,

  /// Состояние платежа
  required final PaymentStateDto state,

  /// Дата создания платежа
  required final DateTime createdAt,

  /// Ссылка на платеж
  final String? url,
}) {
  factory fromJson(Map<String, Object?> json) => _$PaymentDataDtoFromJson(json);

  Map<String, Object?> toJson() => _$PaymentDataDtoToJson(this);
}
