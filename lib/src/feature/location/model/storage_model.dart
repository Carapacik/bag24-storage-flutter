import 'package:bag24/src/feature/location/model/short_location_model.dart';
import 'package:bag24/src/feature/luggage_order/model/rate_data.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/storage/dto/storage_dto.dart';

@immutable
class const Storage({
  required final String id,
  required final bool specialOfferPaymentAllowed,
  required final String status,
  required final String name,
  required final double lon,
  required final double lat,
  required final String photoUrl,
  required final ShortLocation location,
  required final List<RateData> rates,
  required final String? cityName,
  required final String? countryName,
}) {
  factory decode(StorageDto dto) => Storage(
    id: dto.id,
    specialOfferPaymentAllowed: dto.specialOfferPaymentAllowed,
    status: dto.status,
    name: dto.name,
    lon: dto.lon,
    lat: dto.lat,
    photoUrl: dto.photoUrl,
    location: ShortLocation.decode(dto.location),
    rates: dto.rates.map(RateData.decode).toList(),
    cityName: dto.cityName,
    countryName: dto.countryName,
  );

  String get fullName => '${location.name} (${location.iata})${name.isNotEmpty ? ', $name' : ''}';

  String get locationDescription =>
      '${cityName ?? ''}${cityName == null && countryName == null ? '' : ', ${countryName!}'}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Storage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          specialOfferPaymentAllowed == other.specialOfferPaymentAllowed &&
          status == other.status &&
          name == other.name &&
          lon == other.lon &&
          lat == other.lat &&
          photoUrl == other.photoUrl &&
          location == other.location &&
          const DeepCollectionEquality().equals(rates, other.rates);

  @override
  int get hashCode =>
      id.hashCode ^
      specialOfferPaymentAllowed.hashCode ^
      status.hashCode ^
      name.hashCode ^
      lon.hashCode ^
      lat.hashCode ^
      photoUrl.hashCode ^
      location.hashCode ^
      rates.hashCode;
}
