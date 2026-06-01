import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/order/dto/order_luggage_status.dart';
import 'package:rest_client/storage/dto/rate_data_dto.dart';
import 'package:rest_client/storage/dto/special_offer_dto.dart';

part 'order_luggage_dto.g.dart';

@JsonSerializable()
class const OrderLuggageDto({
  /// Идентификатор единицы багажа
  required final String id,

  /// Статус единицы багажа
  required final OrderLuggageStatusDto status,

  /// Идентификатор фотографии
  required final String photoId,

  /// Ссылка на фотографию единицы багажа
  required final String photoUrl,

  /// Сумма оплаты/доплаты за заказ (в минимальных единицах валюты)
  required final int amountToPay,

  /// Сумма за продление хранения единицы багажа
  required final int paidAmount,

  /// Данные тарифа
  required final RateDataDto rate,

  /// Специальное предложение
  final SpecialOfferDto? specialOffer,
}) {
  factory fromJson(Map<String, Object?> json) => _$OrderLuggageDtoFromJson(json);

  Map<String, Object?> toJson() => _$OrderLuggageDtoToJson(this);
}
