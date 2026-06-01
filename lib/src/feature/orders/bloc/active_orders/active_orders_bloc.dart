import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/core/utils/bloc_transformer.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bag24/src/feature/order/model/order_item.dart';
import 'package:bag24/src/feature/order/model/orders_status.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_orders_bloc.freezed.dart';
part 'active_orders_event.dart';
part 'active_orders_state.dart';

final class ActiveOrdersBloc({required final IOrderRepository _orderRepository})
    extends Bloc<ActiveOrdersEvent, ActiveOrdersState> {
  this : super(const ActiveOrdersState.processing([], hasReachedMax: false)) {
    on<_ActiveOrdersStarted>(_start);
    on<_ActiveOrdersStartedFetched>(
      _fetched,
      transformer: ThrottleDroppableBlocTransformer<_ActiveOrdersStartedFetched>().transform,
    );
  }

  static const _limit = 20;

  Future<void> _start(_ActiveOrdersStarted event, Emitter<ActiveOrdersState> emitter) async {
    emitter(const ActiveOrdersState.processing([], hasReachedMax: false));
    await ExceptionHandler.handle(
      () async {
        final List<OrderItem> orders = await _orderRepository.getOrders(status: OrdersStatus.active);
        emitter(ActiveOrdersState.success(orders, hasReachedMax: orders.isEmpty || orders.length < _limit));
      },
      onError: (exception, stackTrace) =>
          emitter(ActiveOrdersState.failure(state.orders, hasReachedMax: state.hasReachedMax, exception: exception)),
    );
  }

  Future<void> _fetched(_ActiveOrdersStartedFetched event, Emitter<ActiveOrdersState> emitter) async {
    if (state.hasReachedMax) {
      return;
    }
    emitter(ActiveOrdersState.fetching(state.orders, hasReachedMax: state.hasReachedMax));
    await ExceptionHandler.handle(
      () async {
        final List<OrderItem> orders = await _orderRepository.getOrders(
          status: OrdersStatus.active,
          offset: state.orders.length,
        );
        emitter(ActiveOrdersState.success(List.of(state.orders)..addAll(orders), hasReachedMax: orders.isEmpty));
      },
      onError: (exception, stackTrace) => emitter(
        ActiveOrdersState.fetchingFailure(state.orders, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
    );
  }
}
