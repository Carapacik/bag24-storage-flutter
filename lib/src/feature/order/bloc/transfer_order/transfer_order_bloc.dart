import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bag24/src/feature/order/model/order_qr.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_order_bloc.freezed.dart';
part 'transfer_order_event.dart';
part 'transfer_order_state.dart';

final class TransferOrderBloc({
  required final IOrderRepository _orderRepository,
  required String orderId,
  required OrderStatus orderStatus,
  required List<String> luggageIds,
}) extends Bloc<TransferOrderEvent, TransferOrderState> {
  this : super(const TransferOrderState.processing('')) {
    on<_TransferOrderStarted>(_start);

    add(TransferOrderEvent.start(orderId, orderStatus, luggageIds));
  }

  Future<void> _start(_TransferOrderStarted event, Emitter<TransferOrderState> emitter) async {
    emitter(TransferOrderState.processing(state.qr));
    await ExceptionHandler.handle(
      () async {
        final OrderQrModel? qrModel = await _getQrModel(event);
        emitter(TransferOrderState.success(qrModel?.qr ?? ''));
      },
      onError: (exception, stackTrace) {
        emitter(TransferOrderState.failure(state.qr, exception: exception));
      },
      onDone: () {
        emitter(TransferOrderState.idle(state.qr));
      },
    );
  }

  Future<OrderQrModel?> _getQrModel(_TransferOrderStarted event) async => await switch (event.orderStatus) {
    OrderStatus.created || OrderStatus.paying || OrderStatus.paid => _orderRepository.depositOrder(event.orderId),
    OrderStatus.depositing ||
    OrderStatus.deposited ||
    OrderStatus.partiallyWithdrawn => _orderRepository.withdrawOrder(event.orderId, luggageIds: event.luggageIds),
    OrderStatus.withdrawing ||
    OrderStatus.withdrawn ||
    OrderStatus.declined ||
    OrderStatus.deleted ||
    OrderStatus.pending => null,
  };
}
