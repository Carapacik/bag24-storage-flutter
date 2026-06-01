import 'package:json_annotation/json_annotation.dart';

part 'luggage_response.g.dart';

@JsonSerializable()
class const LuggageResponse({
  /// Идентификатор заказа
  required final String id,
}) {
  factory fromJson(Map<String, Object?> json) => _$LuggageResponseFromJson(json);

  Map<String, Object?> toJson() => _$LuggageResponseToJson(this);
}
