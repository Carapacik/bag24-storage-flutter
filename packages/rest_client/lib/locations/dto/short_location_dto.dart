import 'package:json_annotation/json_annotation.dart';

part 'short_location_dto.g.dart';

@JsonSerializable()
class const ShortLocationDto({required final String id, required final String name, required final String iata}) {
  factory fromJson(Map<String, Object?> json) => _$ShortLocationDtoFromJson(json);

  Map<String, Object?> toJson() => _$ShortLocationDtoToJson(this);
}
