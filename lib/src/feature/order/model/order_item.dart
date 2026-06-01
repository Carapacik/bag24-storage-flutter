import 'package:bag24/src/feature/order/model/order_luggage.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/order/model/order_storage.dart';
import 'package:rest_client/order/dto/order_item_dto.dart';

class const OrderItem({
  required final String id,
  required final bool specialOfferPaymentAllowed,
  required final OrderStatus status,
  required final String userId,
  required final OrderStorage storage,
  required final List<OrderLuggage> luggage,
  required final DateTime createdAt,
  required final DateTime? depositedAt,
  required final DateTime? withdrawnAt,
}) {
  factory decode(OrderItemDto dto) => OrderItem(
    id: dto.id,
    userId: dto.userId,
    specialOfferPaymentAllowed: dto.specialOfferPaymentAllowed,
    status: OrderStatus.decode(dto.status),
    storage: OrderStorage.decode(dto.storage),
    luggage: dto.luggage.map(OrderLuggage.decode).toList(),
    createdAt: dto.createdAt.add(DateTime.now().timeZoneOffset),
    depositedAt: dto.depositedAt?.add(DateTime.now().timeZoneOffset),
    withdrawnAt: dto.withdrawnAt?.add(DateTime.now().timeZoneOffset),
  );

  DateTime get dateOfChangeWithTimeZone => switch (status) {
    OrderStatus.pending ||
    OrderStatus.created ||
    OrderStatus.deleted ||
    OrderStatus.declined ||
    OrderStatus.paying ||
    OrderStatus.paid => createdAt,
    OrderStatus.depositing => depositedAt ?? createdAt,
    OrderStatus.deposited ||
    OrderStatus.withdrawing ||
    OrderStatus.withdrawn ||
    OrderStatus.partiallyWithdrawn => withdrawnAt ?? createdAt,
  };

  int get amountToPay => luggage.fold(0, (totalCost, luggageItem) => totalCost + luggageItem.amountToPay) ~/ 100;
}
