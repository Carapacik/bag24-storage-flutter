import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/order/dto/order_luggage_dto.dart';
import 'package:rest_client/order/dto/order_status_dto.dart';
import 'package:rest_client/order/dto/order_storage_dto.dart';

part 'order_item_dto.g.dart';

@JsonSerializable()
class const OrderItemDto({
  required final String id,
  required final OrderStatusDto status,
  required final String userId,
  required final OrderStorageDto storage,
  required final List<OrderLuggageDto> luggage,
  required final DateTime createdAt,
  required final bool specialOfferPaymentAllowed,
  final DateTime? depositedAt,
  final DateTime? withdrawnAt,
}) {
  factory fromJson(Map<String, Object?> json) => _$OrderItemDtoFromJson(json);

  Map<String, Object?> toJson() => _$OrderItemDtoToJson(this);
}

@JsonSerializable()
class const OrderListDto({required final List<OrderItemDto> orders}) {
  factory fromJson(Map<String, Object?> json) => _$OrderListDtoFromJson(json);

  Map<String, Object?> toJson() => _$OrderListDtoToJson(this);
}
