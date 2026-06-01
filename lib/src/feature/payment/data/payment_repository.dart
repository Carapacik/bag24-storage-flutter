import 'package:bag24/src/feature/payment/model/binding_model.dart';
import 'package:bag24/src/feature/payment/model/init_payments.dart';
import 'package:bag24/src/feature/payment/model/payment_method.dart';
import 'package:bag24/src/feature/payment/model/payment_model.dart';
import 'package:bag24/src/feature/payment/model/payment_model_converter.dart';
import 'package:rest_client/order/dto/pay_order_command.dart';
import 'package:rest_client/order/order_client.dart';
import 'package:rest_client/payment/payment_client.dart';
import 'package:uuid/uuid.dart';

abstract interface class IPaymentRepository() {
  Future<String> payOrder({
    required String orderId,
    required List<String> luggageIds,
    required PaymentMethod paymentMethod,
    int? miles,
  });

  Future<List<BindingModel>> get bindingCards;

  Future<void> deleteBingingCard(String bindingId);

  Future<List<PaymentModel>> getPayments(String orderId);

  Future<PaymentModel> getPaymentsByPaymentId(String orderId, String paymentId);

  Future<InitPayments> get initPayments;
}

class const PaymentRepository({required final PaymentClient _paymentClient, required final OrderClient _orderClient})
    implements IPaymentRepository {
  @override
  Future<String> payOrder({
    required String orderId,
    required List<String> luggageIds,
    required PaymentMethod paymentMethod,
    int? miles,
  }) => _orderClient
      .payOrder(
        orderId: orderId,
        body: PayOrderCommand(luggageIds: luggageIds, paymentMethod: PaymentMethod.encode(paymentMethod), miles: miles),
        requestId: const Uuid().v4(),
      )
      .then((dto) => dto.result.id);

  @override
  Future<List<BindingModel>> get bindingCards =>
      _paymentClient.getBindings().then((dto) => dto.result.bindings.map(BindingModel.decode).toList());

  @override
  Future<void> deleteBingingCard(String bindingId) => _paymentClient.deleteBinding(bindingId: bindingId);

  @override
  Future<List<PaymentModel>> getPayments(String orderId) => _orderClient
      .getPayments(orderId: orderId)
      .then((dto) => dto.result.payments.map(const PaymentModelDecoder().convert).toList());

  @override
  Future<PaymentModel> getPaymentsByPaymentId(String orderId, String paymentId) => _orderClient
      .getPaymentById(orderId: orderId, paymentId: paymentId)
      .then((dto) => const PaymentModelDecoder().convert(dto.result));

  @override
  Future<InitPayments> get initPayments =>
      _paymentClient.getInitPayments().then((dto) => InitPayments.decode(dto.result));
}
