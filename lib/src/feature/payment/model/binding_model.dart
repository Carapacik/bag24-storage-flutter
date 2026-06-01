import 'package:meta/meta.dart';
import 'package:rest_client/payment/dto/binding_list_dto.dart';

@immutable
class const BindingModel({
  required final String id,
  required final String first6,
  required final String last4,
  required final String cardType,
}) {
  factory decode(BindingDto dto) =>
      BindingModel(id: dto.id, first6: dto.first6, last4: dto.last4, cardType: dto.cardType);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BindingModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          first6 == other.first6 &&
          last4 == other.last4 &&
          cardType == other.cardType;

  @override
  int get hashCode => id.hashCode ^ first6.hashCode ^ last4.hashCode ^ cardType.hashCode;
}

class BindingResult({required final bool isBindCard, required final bool isAutoCharge});
