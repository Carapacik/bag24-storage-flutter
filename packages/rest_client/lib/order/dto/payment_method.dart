import 'package:json_annotation/json_annotation.dart';

part 'payment_method.g.dart';

@JsonSerializable()
class const PaymentMethodDto({
  /// Тип оплаты
  required final PaymentMethodTypeDto type,

  /// Привязать карту
  required final bool? bindCard,

  /// ID привязки карты
  required final String? bindingId,

  /// Включить автосписание
  required final bool? autocharge,
}) {
  factory fromJson(Map<String, Object?> json) => _$PaymentMethodDtoFromJson(json);

  Map<String, Object?> toJson() => _$PaymentMethodDtoToJson(this);
}

/// An enumeration.
@JsonEnum()
enum PaymentMethodTypeDto(final String? json) {
  @JsonValue('BANK_CARD')
  bankCard('BANK_CARD'),
  @JsonValue('SBP')
  sbp('SBP'),
  @JsonValue('BINDING')
  binding('BINDING'),
  @JsonValue('SBERBANK')
  sberbank('SBERBANK'),
  @JsonValue('CASH')
  cash('CASH'),
  @JsonValue('MILES')
  miles('MILES'),
  @JsonValue('MIRPAY')
  mirpay('MIRPAY'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  factory fromJson(String json) => values.firstWhere((e) => e.json == json, orElse: () => $unknown);
}
