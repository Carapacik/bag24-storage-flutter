import 'package:bag24/src/feature/payment/model/payment_method_type.dart';
import 'package:rest_client/order/dto/payment_method.dart';

class const PaymentMethod({
  required final PaymentMethodType type,
  required final bool autoCharge,
  final bool? bindCard,
  final String? bindingId,
}) {
  static PaymentMethodDto encode(PaymentMethod method) => PaymentMethodDto(
    type: PaymentMethodType.encode(method.type),
    bindCard: method.bindCard,
    bindingId: method.bindingId,
    autocharge: method.autoCharge,
  );
}
