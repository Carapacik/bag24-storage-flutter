import 'package:bag24/src/feature/order/model/order_luggage.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/order/model/order_storage.dart';
import 'package:bag24/src/feature/payment/model/payment_method_type.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/order/dto/order_dto.dart';

@immutable
class const OrderDetail({
  required final String id,
  required final bool specialOfferPaymentAllowed,
  required final String userId,
  required final PaymentMethodType? paymentMethod,
  required final OrderStatus status,
  required final OrderStorage storage,
  required final int milesAmount,
  required final List<OrderLuggage> luggage,
  required final bool autoCharge,
  required final String? bindingId,
  required final DateTime createdAt,
  required final DateTime? depositedAt,
  required final DateTime? withdrawnAt,
}) {
  factory decode(OrderDto input) => OrderDetail(
    id: input.id,
    specialOfferPaymentAllowed: input.specialOfferPaymentAllowed,
    userId: input.userId,
    paymentMethod: input.paymentMethod != null ? PaymentMethodType.decode(input.paymentMethod!) : null,
    status: OrderStatus.decode(input.status),
    storage: OrderStorage.decode(input.storage),
    milesAmount: input.milesAmount,
    luggage: input.luggage.map(OrderLuggage.decode).toList(),
    autoCharge: input.autocharge,
    bindingId: input.bindingId,
    createdAt: input.createdAt.add(DateTime.now().timeZoneOffset),
    depositedAt: input.depositedAt?.add(DateTime.now().timeZoneOffset),
    withdrawnAt: input.withdrawnAt?.add(DateTime.now().timeZoneOffset),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDetail &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          specialOfferPaymentAllowed == other.specialOfferPaymentAllowed &&
          status == other.status &&
          paymentMethod == other.paymentMethod &&
          userId == other.userId &&
          storage == other.storage &&
          milesAmount == other.milesAmount &&
          const DeepCollectionEquality().equals(luggage, other.luggage) &&
          autoCharge == other.autoCharge &&
          bindingId == other.bindingId &&
          createdAt == other.createdAt &&
          depositedAt == other.depositedAt &&
          withdrawnAt == other.withdrawnAt;

  @override
  int get hashCode =>
      id.hashCode ^
      specialOfferPaymentAllowed.hashCode ^
      status.hashCode ^
      paymentMethod.hashCode ^
      userId.hashCode ^
      storage.hashCode ^
      milesAmount.hashCode ^
      luggage.hashCode ^
      autoCharge.hashCode ^
      bindingId.hashCode ^
      createdAt.hashCode ^
      depositedAt.hashCode ^
      withdrawnAt.hashCode;

  // сумма доплаты за заказ
  int calculateAmountToPay() => luggage.fold(0, (totalCost, luggageItem) => totalCost + luggageItem.amountToPay) ~/ 100;

  // стоимость всего заказа без скидки
  int calculateCostPerDay() =>
      (luggage.fold(0, (total, item) {
        final int itemCost = item.specialOffer != null
            ? (item.rate.initialPrice + (item.rate.prolongingPrice * ((item.specialOffer?.days ?? 2) - 1)))
            : item.rate.initialPrice;
        return total + itemCost;
      })) ~/
      100;

  // скидка для всего заказа
  int calculateDiscount() => luggage.fold(
    0,
    (totalDiscount, luggageItem) =>
        luggageItem.specialOffer != null ? totalDiscount + _calculateItemDiscount(luggageItem) : totalDiscount,
  );

  int calculatePaidAmount() =>
      luggage.fold(0, (totalPaidAmount, luggageItem) => totalPaidAmount + luggageItem.paidAmount) ~/ 100;

  int calculateAdditionalServicesTotal() =>
      luggage.fold(
        0,
        (totalCost, item) =>
            totalCost +
            (item.rate.additionalServices?.fold(
                  0,
                  (serviceCost, additionalService) => serviceCost! + additionalService.price,
                ) ??
                0),
      ) ~/
      100;

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

  bool areAllLuggageSpecialOfferIdsTheSame() {
    final String? firstSpecialOfferId = luggage.first.specialOffer?.id;
    for (final OrderLuggage luggage in luggage) {
      if (luggage.specialOffer?.id != firstSpecialOfferId) {
        return false;
      }
    }
    return true;
  }

  bool shouldShowQrCodeWithDescription() {
    final bool specialOfferCondition =
        !specialOfferPaymentAllowed && status == OrderStatus.created && _hasAnyLuggageSpecialOffer();
    final bool statusCondition = [
      OrderStatus.created,
      OrderStatus.paying,
      OrderStatus.paid,
      OrderStatus.deposited,
      OrderStatus.partiallyWithdrawn,
    ].contains(status);

    return !specialOfferCondition && statusCondition;
  }

  Iterable<OrderLuggage> withdrawnLuggage() => luggage.where((item) => item.status == OrderLuggageStatus.withdrawn);

  Iterable<OrderLuggage> noWithdrawnLuggage() => luggage.where((item) => item.status != OrderLuggageStatus.withdrawn);

  bool _hasAnyLuggageSpecialOffer() => luggage.firstWhereOrNull((luggage) => luggage.specialOffer != null) != null;

  int _calculateItemDiscount(OrderLuggage luggageItem) {
    // скидка для одного багажа
    final int costWithDiscount =
        luggageItem.specialOffer?.basePrice ?? luggageItem.rate.initialPrice; // стоимость со скидкой
    final int cost =
        luggageItem.rate.initialPrice +
        (luggageItem.rate.prolongingPrice * ((luggageItem.specialOffer?.days ?? 2) - 1)); // стоимость без скидкой
    return (costWithDiscount - cost) ~/ 100;
  }
}
