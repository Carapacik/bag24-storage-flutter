import 'package:dio/dio.dart';
import 'package:rest_client/order/dto/create_order_command.dart';
import 'package:rest_client/order/dto/create_order_response.dart';
import 'package:rest_client/order/dto/get_payments_response.dart';
import 'package:rest_client/order/dto/luggage_command.dart';
import 'package:rest_client/order/dto/luggage_response.dart';
import 'package:rest_client/order/dto/order_dto.dart';
import 'package:rest_client/order/dto/order_item_dto.dart';
import 'package:rest_client/order/dto/order_qr_dto.dart';
import 'package:rest_client/order/dto/order_status_response.dart';
import 'package:rest_client/order/dto/pay_order_command.dart';
import 'package:rest_client/order/dto/pay_order_response.dart';
import 'package:rest_client/order/dto/payment_data_dto.dart';
import 'package:rest_client/order/dto/receipts_list_dto.dart';
import 'package:rest_client/order/dto/withdraw_command.dart';
import 'package:rest_client/result_response.dart';
import 'package:retrofit/retrofit.dart';

part 'order_client.g.dart';

@RestApi()
abstract class OrderClient {
  factory(Dio dio, {String? baseUrl}) = _OrderClient;

  /// Get Orders.
  ///
  /// [limit] - Лимит.
  /// [offset] - Оффсет.
  /// [locationId] - Идентификатор аэропорта.
  /// [status] - Статус заказа (активный/не активный).
  @GET('/v1/orders/')
  Future<ResultResponse<OrderListDto>> getOrders({
    @Query('locationId') String? locationId,
    @Query('limit') int limit = 20,
    @Query('offset') int offset = 0,
    @Query('status') String status = 'ACTIVE',
  });

  /// Init Order.
  ///
  /// Initializing a new order.
  ///
  /// [body] - Идентификатор камеры хранения.
  @POST('/v1/orders/')
  Future<ResultResponse<CreateOrderResponse>> createOrder({@Body() required CreateOrderCommand body});

  /// Get Order.
  ///
  /// [orderId] - Идентификатор заказа.
  @GET('/v1/orders/{orderId}')
  Future<ResultResponse<OrderDto>> getOrder({@Path('orderId') required String orderId});

  /// Change Order.
  ///
  /// [orderId] - Идентификатор заказа.
  @PUT('/v1/orders/{orderId}')
  Future<void> changeOrder({@Path('orderId') required String orderId, @Field() required bool autocharge});

  /// Delete Order.
  ///
  /// Удалить заказ.
  ///
  /// [orderId] - Идентификатор заказа.
  @DELETE('/v1/orders/{orderId}')
  Future<void> deleteOrder({@Path('orderId') required String orderId});

  /// Add Luggage.
  ///
  /// Добавить единицу багажа в заказ.
  ///
  /// [orderId] - Идентификатор заказа.
  @POST('/v1/orders/{orderId}/luggage')
  Future<ResultResponse<LuggageResponse>> addLuggage({
    @Path('orderId') required String orderId,
    @Body() required LuggageCommand body,
  });

  /// Update Luggage.
  ///
  /// Изменить единицу багажа.
  ///
  /// [orderId] - Идентификатор заказа.
  /// [luggageId] - Идентификатор единицы багажа.
  @PUT('/v1/orders/{orderId}/luggage/{luggageId}')
  Future<ResultResponse<LuggageResponse>> updateLuggage({
    @Path('orderId') required String orderId,
    @Path('luggageId') required String luggageId,
    @Body() required LuggageCommand body,
  });

  /// Delete Luggage.
  ///
  /// Удалить единицу багажа.
  ///
  /// [orderId] - Идентификатор заказа.
  /// [luggageId] - Идентификатор единицы багажа.
  @DELETE('/v1/orders/{orderId}/luggage/{luggageId}')
  Future<void> deleteLuggage({@Path('orderId') required String orderId, @Path('luggageId') required String luggageId});

  /// Deposit Order.
  ///
  /// Сдать заказ в камеру хранения.
  ///
  /// [orderId] - Идентификатор заказа.
  @POST('/v1/orders/{orderId}/deposit')
  Future<ResultResponse<OrderQrDto>> depositOrder({@Path('orderId') required String orderId});

  /// Withdraw Order.
  ///
  /// Забрать заказ из камеры хранения.
  ///
  /// [orderId] - Идентификатор заказа.
  @POST('/v1/orders/{orderId}/withdraw')
  Future<ResultResponse<OrderQrDto>> withdrawOrder({
    @Path('orderId') required String orderId,
    @Body() required WithdrawCommand body,
  });

  /// Pay Order.
  ///
  /// Сдать заказ в камеру хранения.
  ///
  /// [orderId] - Идентификатор заказа.
  @POST('/v1/orders/{orderId}/pay')
  Future<ResultResponse<PayOrderResponse>> payOrder({
    @Header('I-Request-Id') required String requestId,
    @Path('orderId') required String orderId,
    @Body() required PayOrderCommand body,
  });

  /// confirmMoa
  ///
  /// [orderId] - Идентификатор заказа.
  @POST('/v1/orders/{orderId}/confirmMOA')
  Future<void> confirmMOA({
    @Header('I-Request-Id') required String requestId,
    @Path('orderId') required String orderId,
    @Field() required String code,
  });

  /// resendMOACode
  ///
  /// [orderId] - Идентификатор заказа.
  @POST('/v1/orders/{orderId}/resendMOACode')
  Future<void> resendMOACode({@Path('orderId') required String orderId});

  /// Cancel Payment.
  ///
  /// Отменить платеж.
  ///
  /// [orderId] - Идентификатор заказа.
  @POST('/v1/orders/{orderId}/cancelPayment')
  Future<void> cancelPayment({@Path('orderId') required String orderId});

  /// Refund Order.
  ///
  /// Возврат денег за оплаченный заказ.
  ///
  /// [orderId] - Идентификатор заказа.
  @POST('/v1/orders/{orderId}/refund')
  Future<void> refundOrder({
    @Header('I-Request-Id') required String requestId,
    @Path('orderId') required String orderId,
  });

  /// Get Payments.
  ///
  /// [orderId] - Идентификатор заказа.
  @GET('/v1/orders/{orderId}/payments')
  Future<ResultResponse<GetPaymentsResponse>> getPayments({@Path('orderId') required String orderId});

  /// Get Payment.
  ///
  /// [orderId] - Идентификатор заказа.
  /// [paymentId] - Идентификатор платежа.
  @GET('/v1/orders/{orderId}/payments/{paymentId}')
  Future<ResultResponse<PaymentDataDto>> getPaymentById({
    @Path('orderId') required String orderId,
    @Path('paymentId') required String paymentId,
  });

  /// Get Receipts.
  ///
  /// Get receipts data.
  ///
  /// [orderId] - Order ID.
  @GET('/v1/orders/{orderId}/receipts')
  Future<ResultResponse<ReceiptsListDto>> getReceipts({@Path('orderId') required String orderId});

  /// Get Order Status.
  ///
  /// [orderId] - Идентификатор заказа.
  @GET('/v1/orders/{orderId}/status')
  Future<ResultResponse<OrderStatusResponse>> getStatus({@Path('orderId') required String orderId});
}
