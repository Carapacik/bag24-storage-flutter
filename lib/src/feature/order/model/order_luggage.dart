import 'package:bag24/src/feature/luggage_order/model/rate_data.dart';
import 'package:bag24/src/feature/luggage_order/model/special_offer.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/order/dto/order_luggage_dto.dart';
import 'package:rest_client/order/dto/order_luggage_status.dart';

@immutable
class const OrderLuggage({
  required final String id,
  required final OrderLuggageStatus status,
  required final String photoId,
  required final String photoUrl,
  required final int amountToPay,
  required final int paidAmount,
  required final RateData rate,
  final SpecialOffer? specialOffer,
}) {
  factory decode(OrderLuggageDto dto) => OrderLuggage(
    id: dto.id,
    status: OrderLuggageStatus.decode(dto.status),
    photoId: dto.photoId,
    photoUrl: dto.photoUrl,
    amountToPay: dto.amountToPay,
    paidAmount: dto.paidAmount,
    rate: RateData.decode(dto.rate),
    specialOffer: dto.specialOffer != null ? SpecialOffer.decode(dto.specialOffer!) : null,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderLuggage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          status == other.status &&
          photoId == other.photoId &&
          photoUrl == other.photoUrl &&
          amountToPay == other.amountToPay &&
          paidAmount == other.paidAmount &&
          rate == other.rate &&
          specialOffer == other.specialOffer;

  @override
  int get hashCode =>
      id.hashCode ^
      status.hashCode ^
      photoId.hashCode ^
      photoUrl.hashCode ^
      amountToPay.hashCode ^
      paidAmount.hashCode ^
      rate.hashCode ^
      specialOffer.hashCode;

  @override
  String toString() => 'OrderLuggage($id, status: $status, rate: $rate)';
}

enum OrderLuggageStatus(final String value) {
  created('CREATED'),
  deposited('DEPOSITED'),
  withdrawn('WITHDRAWN'),
  deleted('DELETED');

  factory decode(OrderLuggageStatusDto status) => OrderLuggageStatus.values.firstWhere((e) => status.json == e.value);

  factory fromString(String value) => OrderLuggageStatus.values.firstWhere((status) => status.value == value);
}
