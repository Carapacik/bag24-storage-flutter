import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/order/dto/order_luggage_dto.dart';
import 'package:rest_client/order/dto/order_status_dto.dart';
import 'package:rest_client/order/dto/order_storage_dto.dart';
import 'package:rest_client/order/dto/payment_method.dart';

part 'order_dto.g.dart';

@JsonSerializable()
class const OrderDto({
  /// Идентификатор заказа
  required final String id,

  /// Возможность оплаты СП наличными
  required final bool specialOfferPaymentAllowed,

  /// Статус заказа
  required final OrderStatusDto status,

  /// Идентификатор пользователя
  required final String userId,

  /// Данные камеры хранения
  required final OrderStorageDto storage,

  /// Сумма оплаты в милях MileOnAir
  required final int milesAmount,

  /// Данные единиц багажа
  required final List<OrderLuggageDto> luggage,

  /// Дата создания
  required final DateTime createdAt,

  /// Автооплата
  required final bool autocharge,

  /// ID привязки карты
  final String? bindingId,

  /// Способ оплаты
  final PaymentMethodTypeDto? paymentMethod,

  /// Дата сдачи заказа на хранение
  final DateTime? depositedAt,

  /// Дата выдачи заказа их камеры хранения
  final DateTime? withdrawnAt,
}) {
  factory fromJson(Map<String, Object?> json) => _$OrderDtoFromJson(json);

  Map<String, Object?> toJson() => _$OrderDtoToJson(this);
}
