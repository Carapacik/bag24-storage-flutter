import 'package:json_annotation/json_annotation.dart';

part 'pay_order_response.g.dart';

@JsonSerializable()
class const PayOrderResponse({
  /// Идентификатор платежа
  required final String id,
}) {
  factory fromJson(Map<String, Object?> json) => _$PayOrderResponseFromJson(json);

  Map<String, Object?> toJson() => _$PayOrderResponseToJson(this);
}
