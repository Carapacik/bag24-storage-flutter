// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'app_state_dto.g.dart';

@JsonSerializable()
class AppStateDto {
  const AppStateDto({
    required this.name,
    required this.lastVersion,
    required this.lastSupportedVersion,
    required this.technicalWorks,
  });

  factory AppStateDto.fromJson(Map<String, Object?> json) => _$AppStateDtoFromJson(json);

  /// Наименование сервиса
  final String name;

  /// Последняя версия
  final String lastVersion;

  /// Последняя поддерживаемая версия
  final String lastSupportedVersion;

  /// Технические работы
  final bool technicalWorks;

  Map<String, Object?> toJson() => _$AppStateDtoToJson(this);
}
