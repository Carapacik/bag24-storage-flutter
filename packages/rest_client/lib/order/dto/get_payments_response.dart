import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/order/dto/payment_data_dto.dart';

part 'get_payments_response.g.dart';

@JsonSerializable()
class const GetPaymentsResponse({
  /// Данные платежей
  required final List<PaymentDataDto> payments,
}) {
  factory fromJson(Map<String, Object?> json) => _$GetPaymentsResponseFromJson(json);

  Map<String, Object?> toJson() => _$GetPaymentsResponseToJson(this);
}
