import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/order/dto/order_status_dto.dart';

part 'order_status_response.g.dart';

@JsonSerializable()
class const OrderStatusResponse({
  /// Идентификатор заказа
  required final String id,

  /// Статус заказа
  required final OrderStatusDto status,
}) {
  factory fromJson(Map<String, Object?> json) => _$OrderStatusResponseFromJson(json);

  Map<String, Object?> toJson() => _$OrderStatusResponseToJson(this);
}
