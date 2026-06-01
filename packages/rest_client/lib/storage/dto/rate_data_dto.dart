import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/storage/dto/additional_services_dto.dart';
import 'package:rest_client/storage/dto/special_offer_dto.dart';

part 'rate_data_dto.g.dart';

@JsonSerializable()
class const RateDataDto({
  /// Идентификатор тарифа
  required final String id,

  /// Название тарифа
  required final String title,

  /// Описание тарифа
  required final String description,

  /// Описание габаритов багажа
  required final String sizeDescription,

  /// Сумма сдачи багажа на хранения (в минимальных единицах валюты)
  required final int initialPrice,

  /// Сумма продления хранения багажая (в минимальных единицах валюты)
  required final int prolongingPrice,

  /// Рейт по умолчанию.
  /// The name has been replaced because it contains a keyword. Original name: `default`.
  @JsonKey(name: 'default') final bool? defaultValue,

  /// Данные специальных предложений
  final List<SpecialOfferDto>? specialOffers,

  /// Дополнительные услуги
  final List<AdditionalServicesDto>? additionalServices,
}) {
  factory fromJson(Map<String, Object?> json) => _$RateDataDtoFromJson(json);

  Map<String, Object?> toJson() => _$RateDataDtoToJson(this);
}
