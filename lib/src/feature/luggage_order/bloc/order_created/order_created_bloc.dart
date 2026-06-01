import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bag24/src/feature/order/model/order_detail.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_created_bloc.freezed.dart';
part 'order_created_event.dart';
part 'order_created_state.dart';

final class OrderCreatedBloc({required final String _orderId, required final IOrderRepository _orderRepository})
    extends Bloc<OrderCreatedEvent, OrderCreatedState> {
  this : super(const OrderCreatedState.processing(null)) {
    on<_StartOrderCreatedEvent>(_start);

    add(const OrderCreatedEvent.start());
  }

  Future<void> _start(_StartOrderCreatedEvent event, Emitter<OrderCreatedState> emitter) async {
    emitter(const OrderCreatedState.processing(null));
    await ExceptionHandler.handle(
      () async {
        final OrderDetail order = await _orderRepository.getOrder(_orderId);
        emitter(OrderCreatedState.success(order));
      },
      onError: (exception, stackTrace) => emitter(OrderCreatedState.failure(state.order, exception: exception)),
      onDone: () => emitter(OrderCreatedState.idle(state.order)),
    );
  }
}
