import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bag24/src/feature/order/model/receipt.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_receipts_bloc.freezed.dart';
part 'order_receipts_event.dart';
part 'order_receipts_state.dart';

final class OrderReceiptsBloc({required final IOrderRepository _orderRepository})
    extends Bloc<OrderReceiptsEvent, OrderReceiptsState> {
  this : super(const OrderReceiptsState.idle()) {
    on<_OrderReceiptsStarted>(_start);
  }

  Future<void> _start(_OrderReceiptsStarted event, Emitter<OrderReceiptsState> emitter) async {
    emitter(const OrderReceiptsState.processing());
    await ExceptionHandler.handle(() async {
      final List<Receipt> receipts = await _orderRepository.getReceipts(event.orderId);
      emitter(OrderReceiptsState.success(receipts));
    }, onError: (exception, stackTrace) async => emitter(OrderReceiptsState.failure(exception: exception)));
  }
}
