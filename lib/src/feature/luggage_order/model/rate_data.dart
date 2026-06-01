import 'package:bag24/src/feature/luggage_order/model/additional_service.dart';
import 'package:bag24/src/feature/luggage_order/model/special_offer.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/storage/dto/rate_data_dto.dart';

@immutable
class const RateData({
  required final String id,
  required final String title,
  required final String description,
  required final String sizeDescription,
  required final int initialPrice,
  required final int prolongingPrice,
  final List<SpecialOffer>? specialOffers,
  final bool? defaultValue,
  final List<AdditionalService>? additionalServices,
}) {
  factory decode(RateDataDto dto) => RateData(
    id: dto.id,
    title: dto.title,
    description: dto.description,
    sizeDescription: dto.sizeDescription,
    initialPrice: dto.initialPrice,
    prolongingPrice: dto.prolongingPrice,
    specialOffers: dto.specialOffers?.map(SpecialOffer.decode).toList(),
    defaultValue: dto.defaultValue,
    additionalServices: dto.additionalServices?.map(AdditionalService.decode).toList(),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RateData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          sizeDescription == other.sizeDescription &&
          initialPrice == other.initialPrice &&
          prolongingPrice == other.prolongingPrice &&
          const DeepCollectionEquality().equals(specialOffers, other.specialOffers) &&
          defaultValue == other.defaultValue &&
          const DeepCollectionEquality().equals(additionalServices, other.additionalServices);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      sizeDescription.hashCode ^
      initialPrice.hashCode ^
      prolongingPrice.hashCode ^
      specialOffers.hashCode ^
      defaultValue.hashCode ^
      additionalServices.hashCode;

  @override
  String toString() => 'RateData($id, $title)';
}
