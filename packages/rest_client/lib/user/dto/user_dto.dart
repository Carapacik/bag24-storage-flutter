import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class const UserRawDto({required final UserDto user}) {
  factory fromJson(Map<String, Object?> json) => _$UserRawDtoFromJson(json);

  Map<String, Object?> toJson() => _$UserRawDtoToJson(this);
}

@JsonSerializable()
class const UserDto({
  required final String id,
  required final String phoneNumber,
  required final UserStatus status,
  final String? firstName,
  final String? lastName,
  final UserSexTypeDto? sex,
  final DateTime? birthDate,
}) {
  factory fromJson(Map<String, Object?> json) => _$UserDtoFromJson(json);

  Map<String, Object?> toJson() => _$UserDtoToJson(this);
}

@JsonEnum()
enum UserSexTypeDto(final String json) {
  @JsonValue('MALE')
  male('MALE'),
  @JsonValue('FEMALE')
  female('FEMALE');

  factory fromJson(String json) => values.firstWhere((e) => e.json == json);
}

@JsonEnum()
enum UserStatus(final String json) {
  @JsonValue('INIT')
  init('INIT'),
  @JsonValue('REGISTERED')
  registered('REGISTERED'),
  @JsonValue('ACTIVE')
  active('ACTIVE'),
  @JsonValue('DELETED')
  deleted('DELETED');

  factory fromJson(String json) => values.firstWhere((e) => e.json == json);
}
