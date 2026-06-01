import 'package:json_annotation/json_annotation.dart';

part 'location_dto.g.dart';

@JsonSerializable()
class const LocationDto({
  /// Location ID
  required final String id,

  /// Location Type
  required final String type,

  /// Location Name
  required final String name,

  /// Location Short Name
  required final String shortName,

  /// Location Status
  required final LocationStatusTypeDto status,

  /// Coverage photo name
  required final String photoUrl,

  /// Location City
  required final String city,

  /// Location Country
  required final String country,

  /// Location coordinates
  required final CoordinatesDataDto coordinates,

  /// Location area
  required final AreaDataDto area,

  /// Distance to location
  final int? distance,
}) {
  factory fromJson(Map<String, Object?> json) => _$LocationDtoFromJson(json);

  Map<String, Object?> toJson() => _$LocationDtoToJson(this);
}

@JsonSerializable()
class const CoordinatesDataDto({required final String type, required final List<double> coordinates}) {
  factory fromJson(Map<String, Object?> json) => _$CoordinatesDataDtoFromJson(json);

  Map<String, Object?> toJson() => _$CoordinatesDataDtoToJson(this);
}

@JsonSerializable()
class const AreaDataDto({required final String type, required final List<List<List<double>>> coordinates}) {
  factory fromJson(Map<String, Object?> json) => _$AreaDataDtoFromJson(json);

  Map<String, Object?> toJson() => _$AreaDataDtoToJson(this);
}

@JsonSerializable()
class const LocationListDto({
  /// List of available locations
  required final List<LocationDto> locations,
}) {
  factory fromJson(Map<String, Object?> json) => _$LocationListDtoFromJson(json);

  Map<String, Object?> toJson() => _$LocationListDtoToJson(this);
}

@JsonEnum()
enum LocationStatusTypeDto(final String json) {
  @JsonValue('ACTIVE')
  active('ACTIVE'),
  @JsonValue('INACTIVE')
  inactive('INACTIVE');

  factory fromJson(String json) => values.firstWhere((e) => e.json == json);
}
