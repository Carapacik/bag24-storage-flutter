import 'package:json_annotation/json_annotation.dart';

part 'luggage_command.g.dart';

@JsonSerializable(includeIfNull: false)
class const LuggageCommand({
  /// Идентификатор тарифа
  required final String rateId,

  /// Идентификатор фотографии единица багажа
  required final String photoId,

  /// Идентификатор специального предложения
  final String? specialOfferId,
}) {
  factory fromJson(Map<String, Object?> json) => _$LuggageCommandFromJson(json);

  Map<String, Object?> toJson() => _$LuggageCommandToJson(this);
}
