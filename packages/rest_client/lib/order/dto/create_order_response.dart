import 'package:json_annotation/json_annotation.dart';

part 'create_order_response.g.dart';

@JsonSerializable()
class const CreateOrderResponse({
  /// Идентификатор заказа
  required final String id,
}) {
  factory fromJson(Map<String, Object?> json) => _$CreateOrderResponseFromJson(json);

  Map<String, Object?> toJson() => _$CreateOrderResponseToJson(this);
}
