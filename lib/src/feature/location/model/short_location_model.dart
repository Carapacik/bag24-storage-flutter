import 'package:meta/meta.dart';
import 'package:rest_client/locations/dto/short_location_dto.dart';

@immutable
class const ShortLocation({required final String id, required final String name, required final String iata}) {
  factory decode(ShortLocationDto dto) => ShortLocation(id: dto.id, name: dto.name, iata: dto.iata);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShortLocation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          iata == other.iata;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ iata.hashCode;
}
