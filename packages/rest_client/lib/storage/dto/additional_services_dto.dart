import 'package:json_annotation/json_annotation.dart';

part 'additional_services_dto.g.dart';

@JsonSerializable()
class const AdditionalServicesDto({
  /// Идентификатор дополнительной услуги
  required final String id,

  /// Наименование дополнительной услуги
  required final String name,

  /// Стоимость дополнительной услуги
  required final int price,
}) {
  factory fromJson(Map<String, Object?> json) => _$AdditionalServicesDtoFromJson(json);

  Map<String, Object?> toJson() => _$AdditionalServicesDtoToJson(this);
}
