import 'package:json_annotation/json_annotation.dart';

part 'special_offer_dto.g.dart';

@JsonSerializable()
class const SpecialOfferDto({
  /// Идентификатор специального предложения
  required final String id,

  /// Название специального предложения
  required final String name,

  /// Колличество дней в специальном предложении
  required final int days,

  /// Базовая цена специального предложения в минимальных единицаю валюты
  required final int basePrice,
}) {
  factory fromJson(Map<String, Object?> json) => _$SpecialOfferDtoFromJson(json);

  Map<String, Object?> toJson() => _$SpecialOfferDtoToJson(this);
}
