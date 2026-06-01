import 'package:json_annotation/json_annotation.dart';

part 'miles_response_dto.g.dart';

@JsonSerializable()
class const MilesResponseDto({required final int miles}) {
  factory fromJson(Map<String, Object?> json) => _$MilesResponseDtoFromJson(json);

  Map<String, Object?> toJson() => _$MilesResponseDtoToJson(this);
}
