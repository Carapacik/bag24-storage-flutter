import 'dart:async';

import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cancel_order_bloc.freezed.dart';
part 'cancel_order_event.dart';
part 'cancel_order_state.dart';

final class CancelOrderBloc({required final String _orderId, required final IOrderRepository _orderRepository})
    extends Bloc<CancelOrderEvent, CancelOrderState> {
  this : super(const CancelOrderState.idle()) {
    on<_CancelOrderCancel>(_cancel);
    on<_CancelOrderRefund>(_refund);
  }

  Future<void> _cancel(_CancelOrderCancel event, Emitter<CancelOrderState> emitter) async {
    emitter(const CancelOrderState.processing());
    await ExceptionHandler.handle(
      () async {
        await _orderRepository.deleteOrder(_orderId);
        emitter(const CancelOrderState.success());
      },
      onError: (exception, stackTrace) => emitter(CancelOrderState.failure(exception: exception)),
      onDone: () => emitter(const CancelOrderState.idle()),
    );
  }

  Future<void> _refund(_CancelOrderRefund event, Emitter<CancelOrderState> emitter) async {
    emitter(const CancelOrderState.processing());
    await ExceptionHandler.handle(
      () async {
        await _orderRepository.refundOrder(_orderId);
        emitter(const CancelOrderState.success());
      },
      onError: (exception, stackTrace) => emitter(CancelOrderState.failure(exception: exception)),
      onDone: () => emitter(const CancelOrderState.idle()),
    );
  }
}
