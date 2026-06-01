import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/locations/dto/short_location_dto.dart';
import 'package:rest_client/storage/dto/rate_data_dto.dart';

part 'storage_dto.g.dart';

@JsonSerializable()
class const StorageDto({
  /// Идентификатор камеры хранения
  required final String id,

  /// Возможность оплаты СП наличными
  required final bool specialOfferPaymentAllowed,

  /// Статус камеры хранения
  required final String status,

  /// Название камеры хранения
  required final String name,

  /// Долгота координат камеры хранения
  required final double lon,

  /// Широта координат камеры хранения
  required final double lat,

  /// Ссылка на изображения камеры хранения
  required final String photoUrl,

  /// Локации
  required final ShortLocationDto location,
  final String? cityName,
  final String? countryName,

  /// Данные о тарифах
  final List<RateDataDto> rates = const [],
}) {
  factory fromJson(Map<String, Object?> json) => _$StorageDtoFromJson(json);

  Map<String, Object?> toJson() => _$StorageDtoToJson(this);
}

@JsonSerializable()
class const StorageListDto({required final List<StorageDto> storages}) {
  factory fromJson(Map<String, Object?> json) => _$StorageListDtoFromJson(json);

  Map<String, Object?> toJson() => _$StorageListDtoToJson(this);
}
