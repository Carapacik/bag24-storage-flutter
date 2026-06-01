// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'app_state_dto.dart';

part 'get_state_response.g.dart';

@JsonSerializable()
class GetStateResponse {
  const GetStateResponse({required this.states});

  factory GetStateResponse.fromJson(Map<String, Object?> json) => _$GetStateResponseFromJson(json);

  /// Данные о состоянии сервиса
  final List<AppStateDto> states;

  Map<String, Object?> toJson() => _$GetStateResponseToJson(this);
}
