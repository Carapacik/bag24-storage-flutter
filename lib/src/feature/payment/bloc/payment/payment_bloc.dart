import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/payment/data/payment_repository.dart';
import 'package:bag24/src/feature/payment/model/binding_model.dart';
import 'package:bag24/src/feature/payment/model/payment_method.dart';
import 'package:bag24/src/feature/payment/model/payment_method_type.dart';
import 'package:bag24/src/feature/payment/model/payment_model.dart';
import 'package:bag24/src/feature/payment/model/payment_status.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_bloc.freezed.dart';
part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc({
  required final String _orderId,
  required final List<String> _luggageIds,
  required final IPaymentRepository _paymentRepository,
  required final IOrderRepository _orderRepository,
}) extends Bloc<PaymentEvent, PaymentState> {
  this : super(const PaymentState.idle()) {
    on<PaymentEvent>(
      (event, emit) async => await switch (event) {
        final _PaymentEventProcessPayment e => _processPayment(e, emit),
        final _PaymentEventCancelPayment e => _cancelPayment(e, emit),
        final _PaymentEventCheckPaymentStatus e => _checkPaymentStatus(e, emit),
      },
    );
  }

  Future<void> _processPayment(_PaymentEventProcessPayment event, Emitter<PaymentState> emit) async {
    emit(const PaymentState.processing());

    await ExceptionHandler.handle(
      () async {
        await _checkOrderStatusForPayment();

        final String paymentId = await _paymentRepository.payOrder(
          orderId: _orderId,
          luggageIds: _luggageIds,
          paymentMethod: PaymentMethod(
            type: event.paymentMethodType,
            bindCard: event.bindingResult?.isBindCard ?? false,
            bindingId: event.bindingId,
            autoCharge: event.bindingResult?.isAutoCharge ?? false,
          ),
          miles: event.milesToUse ?? 0,
        );

        emit(PaymentState.processing(paymentId: paymentId));
      },
      onError: (exception, stackTrace) {
        emit(PaymentState.failure(exception: exception));
      },
    );
  }

  Future<void> _cancelPayment(_PaymentEventCancelPayment event, Emitter<PaymentState> emit) async {
    await ExceptionHandler.handle(
      () async {
        await _orderRepository.cancelPayment(_orderId);
        emit(const PaymentState.idle());
      },
      onError: (exception, stackTrace) {
        emit(PaymentState.failure(exception: exception));
      },
    );
  }

  Future<void> _checkPaymentStatus(_PaymentEventCheckPaymentStatus event, Emitter<PaymentState> emit) async {
    await ExceptionHandler.handle(
      () async {
        if (state.paymentId != null) {
          final PaymentModel payment = await _paymentRepository.getPaymentsByPaymentId(_orderId, state.paymentId!);
          final OrderStatus orderStatus = await _orderRepository.getStatus(_orderId);

          emit(
            PaymentState.success(
              orderId: _orderId,
              paymentId: state.paymentId,
              luggageIds: _luggageIds,
              orderStatus: orderStatus,
              paymentStatus: payment.status,
              paymentUrl: payment.url,
            ),
          );
        }
      },
      onError: (exception, stackTrace) {
        emit(PaymentState.failure(exception: exception));
      },
    );
  }

  Future<OrderStatus> _checkOrderStatusForPayment() async {
    final OrderStatus orderStatus = await _orderRepository.getStatus(_orderId);
    if (orderStatus == OrderStatus.paying) {
      await _orderRepository.cancelPayment(_orderId);
      const maxAttempts = 10;
      for (var attempt = 0; attempt < maxAttempts; attempt++) {
        final OrderStatus orderStatus = await _orderRepository.getStatus(_orderId);
        if (orderStatus != OrderStatus.paying) {
          return orderStatus;
        }
        await Future<void>.delayed(const Duration(seconds: 2));
      }
    }
    return orderStatus;
  }
}
