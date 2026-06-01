import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/core/utils/bloc_transformer.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bag24/src/feature/order/model/order_item.dart';
import 'package:bag24/src/feature/order/model/orders_status.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inactive_orders_bloc.freezed.dart';
part 'inactive_orders_event.dart';
part 'inactive_orders_state.dart';

final class InactiveOrdersBloc({required final IOrderRepository _orderRepository})
    extends Bloc<InactiveOrdersEvent, InactiveOrdersState> {
  this : super(const InactiveOrdersState.processing([], hasReachedMax: false)) {
    on<_InactiveOrdersStarted>(_start);
    on<_InactiveOrdersFetched>(
      _fetched,
      transformer: ThrottleDroppableBlocTransformer<_InactiveOrdersFetched>().transform,
    );
  }

  static const _limit = 20;

  Future<void> _start(_InactiveOrdersStarted event, Emitter<InactiveOrdersState> emitter) async {
    emitter(const InactiveOrdersState.processing([], hasReachedMax: false));
    await ExceptionHandler.handle(
      () async {
        final List<OrderItem> orders = await _orderRepository.getOrders(status: OrdersStatus.inactive);
        emitter(InactiveOrdersState.success(orders, hasReachedMax: orders.isEmpty || orders.length < _limit));
      },
      onError: (exception, stackTrace) =>
          emitter(InactiveOrdersState.failure(state.orders, hasReachedMax: state.hasReachedMax, exception: exception)),
    );
  }

  Future<void> _fetched(_InactiveOrdersFetched event, Emitter<InactiveOrdersState> emitter) async {
    if (state.hasReachedMax) {
      return;
    }
    emitter(InactiveOrdersState.fetching(state.orders, hasReachedMax: state.hasReachedMax));
    await ExceptionHandler.handle(
      () async {
        final List<OrderItem> orders = await _orderRepository.getOrders(
          status: OrdersStatus.inactive,
          offset: state.orders.length,
        );
        emitter(InactiveOrdersState.success(List.of(state.orders)..addAll(orders), hasReachedMax: orders.isEmpty));
      },
      onError: (exception, stackTrace) => emitter(
        InactiveOrdersState.fetchingFailure(state.orders, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
    );
  }
}
