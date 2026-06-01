import 'package:flutter/foundation.dart';
import 'package:rest_client/locations/dto/location_dto.dart';

@immutable
class const Location({
  required final String id,
  required final String type,
  required final String name,
  required final String shortName,
  required final String status,
  required final String photoUrl,
  required final String city,
  required final String country,
  required final CoordinatesData coordinates,
  required final AreaData area,
  final int? distance,
}) {
  factory decode(LocationDto dto) => Location(
    id: dto.id,
    type: dto.type,
    name: dto.name,
    shortName: dto.shortName,
    status: dto.status.json,
    photoUrl: dto.photoUrl,
    city: dto.city,
    country: dto.country,
    coordinates: CoordinatesData.decode(dto.coordinates),
    area: AreaData.decode(dto.area),
    distance: dto.distance,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          name == other.name &&
          shortName == other.shortName &&
          status == other.status &&
          photoUrl == other.photoUrl &&
          city == other.city &&
          country == other.country &&
          distance == other.distance &&
          coordinates == other.coordinates &&
          area == other.area;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      name.hashCode ^
      shortName.hashCode ^
      status.hashCode ^
      photoUrl.hashCode ^
      city.hashCode ^
      country.hashCode ^
      distance.hashCode ^
      coordinates.hashCode ^
      area.hashCode;
}

@immutable
class const CoordinatesData({required final String type, required final List<double> coordinates}) {
  factory decode(CoordinatesDataDto dto) =>
      CoordinatesData(type: dto.type, coordinates: dto.coordinates.map((e) => e).toList(growable: false));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoordinatesData &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          listEquals(coordinates, other.coordinates);

  @override
  int get hashCode => type.hashCode ^ coordinates.hashCode;

  @override
  String toString() => 'CoordinatesData(type: $type, coordinates: $coordinates)';
}

@immutable
class const AreaData({required final String type, required final List<List<List<double>>> coordinates}) {
  factory decode(AreaDataDto dto) => AreaData(
    type: dto.type,
    coordinates: dto.coordinates.map((e) => e.map((e) => e.map((e) => e).toList()).toList()).toList(growable: false),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AreaData && runtimeType == other.runtimeType && type == other.type;

  @override
  int get hashCode => type.hashCode ^ coordinates.hashCode;

  @override
  String toString() => 'AreaData(type: $type, coordinates: $coordinates)';
}
