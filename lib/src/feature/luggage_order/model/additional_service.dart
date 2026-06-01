import 'package:meta/meta.dart';
import 'package:rest_client/storage/dto/additional_services_dto.dart';

@immutable
class const AdditionalService({required final String id, required final String name, required final int price}) {
  factory decode(AdditionalServicesDto dto) => AdditionalService(id: dto.id, name: dto.name, price: dto.price);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdditionalService &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ price.hashCode;
}
