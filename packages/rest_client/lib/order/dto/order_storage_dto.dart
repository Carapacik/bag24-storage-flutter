import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/locations/dto/short_location_dto.dart';

part 'order_storage_dto.g.dart';

@JsonSerializable()
class const OrderStorageDto({
  /// Идентификатор камеры хранения
  required final String id,

  /// Название камеры хранения
  required final String name,

  /// Данные аэропорта
  required final ShortLocationDto location,
}) {
  factory fromJson(Map<String, Object?> json) => _$OrderStorageDtoFromJson(json);

  Map<String, Object?> toJson() => _$OrderStorageDtoToJson(this);
}
