import 'package:bag24/src/feature/location/model/short_location_model.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/order/dto/order_storage_dto.dart';

@immutable
class const OrderStorage({
  required final String id,
  required final String name,
  required final ShortLocation location,
}) {
  factory decode(OrderStorageDto dto) =>
      OrderStorage(id: dto.id, name: dto.name, location: ShortLocation.decode(dto.location));

  String get fullName => '${location.name} (${location.iata})${name.isNotEmpty ? ', $name' : ''}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStorage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          location == other.location;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ location.hashCode;
}
