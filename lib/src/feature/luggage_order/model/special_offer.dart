import 'package:meta/meta.dart';
import 'package:rest_client/storage/dto/special_offer_dto.dart';

@immutable
class const SpecialOffer({
  required final String id,
  required final String name,
  required final int days,
  required final int basePrice,
}) {
  factory decode(SpecialOfferDto dto) =>
      SpecialOffer(id: dto.id, name: dto.name, days: dto.days, basePrice: dto.basePrice);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialOffer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          days == other.days &&
          basePrice == other.basePrice;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ days.hashCode ^ basePrice.hashCode;
}
