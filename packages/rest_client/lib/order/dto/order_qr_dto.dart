import 'package:json_annotation/json_annotation.dart';

part 'order_qr_dto.g.dart';

@JsonSerializable()
class const OrderQrDto({
  /// QR код
  required final String qr,

  /// Времся жизни QR кода в секундах
  required final int ttl,

  /// Сумма к оплате в кх
  required final int amountToPay,
}) {
  factory fromJson(Map<String, Object?> json) => _$OrderQrDtoFromJson(json);

  Map<String, Object?> toJson() => _$OrderQrDtoToJson(this);
}
