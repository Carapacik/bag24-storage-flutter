import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/order/dto/luggage_command.dart';

part 'create_order_command.g.dart';

@JsonSerializable()
class const CreateOrderCommand({
  /// Идентификатор камеры хранения
  required final String storageId,

  /// Данные единиц багажа
  required final List<LuggageCommand> luggage,
}) {
  factory fromJson(Map<String, Object?> json) => _$CreateOrderCommandFromJson(json);

  Map<String, Object?> toJson() => _$CreateOrderCommandToJson(this);
}
