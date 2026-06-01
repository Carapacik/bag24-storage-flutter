import 'dart:async';

import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/location/data/storage_repository.dart';
import 'package:bag24/src/feature/location/model/storage_model.dart';
import 'package:bag24/src/feature/luggage_order/model/rate_data.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bag24/src/feature/order/model/order_detail.dart';
import 'package:bag24/src/feature/payment/data/payment_repository.dart';
import 'package:bag24/src/feature/payment/model/binding_model.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'order_detail_bloc.freezed.dart';
part 'order_detail_event.dart';
part 'order_detail_state.dart';

final class OrderDetailBloc({
  required final String _orderId,
  required final IOrderRepository _orderRepository,
  required final IPaymentRepository _paymentRepository,
  required final IStorageRepository _storageRepository,
}) extends Bloc<OrderDetailEvent, OrderDetailState> {
  this : super(const OrderDetailState.processing(null, rates: [], isCardsAvailable: false, isInitialProcessing: true)) {
    on<_OrderDetailStarted>(_start);
    on<_OrderDetailUpdateStatus>(_updateStatus);
    on<_OrderDetailChangeAutoCharge>(_changeAutoCharge);
    on<_OrderDetailStartListening>(_startListening);
    on<_OrderDetailCancelListening>(_cancelListening);

    // in future = socket
    _statusStream = Stream<void>.periodic(const Duration(seconds: 10))
        .delay(const Duration(seconds: 10))
        .asBroadcastStream();
  }

  late final Stream<void> _statusStream;
  StreamSubscription<void>? _statusSubscription;

  @override
  Future<void> close() async {
    await _statusSubscription?.cancel();
    unawaited(super.close());
  }

  Future<void> _start(_OrderDetailStarted event, Emitter<OrderDetailState> emitter) async {
    emitter(
      OrderDetailState.processing(
        state.order,
        rates: state.rates,
        isCardsAvailable: state.isCardsAvailable,
        isInitialProcessing: true,
      ),
    );
    await ExceptionHandler.handle(
      () async {
        final OrderDetail order = await _orderRepository.getOrder(_orderId);
        final Storage storage = await _storageRepository.getStorageById(order.storage.id);
        final List<BindingModel> cards = await _paymentRepository.bindingCards;

        emitter(OrderDetailState.success(order, rates: storage.rates, isCardsAvailable: cards.isNotEmpty));

        add(const OrderDetailEvent.startListening());
      },
      onError: (exception, stackTrace) {
        emitter(
          OrderDetailState.failure(
            state.order,
            rates: state.rates,
            isCardsAvailable: state.isCardsAvailable,
            exception: exception,
          ),
        );
      },
      onDone: () {
        emitter(OrderDetailState.idle(state.order, rates: state.rates, isCardsAvailable: state.isCardsAvailable));
      },
    );
  }

  Future<void> _updateStatus(_OrderDetailUpdateStatus event, Emitter<OrderDetailState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        final OrderDetail order = await _orderRepository.getOrder(_orderId);
        if (event.updateComposition) {
          emitter(OrderDetailState.success(order, rates: state.rates, isCardsAvailable: state.isCardsAvailable));
        } else {
          emitter(OrderDetailState.idle(order, rates: state.rates, isCardsAvailable: state.isCardsAvailable));
        }
      },
      onError: (exception, stackTrace) {
        emitter(
          OrderDetailState.failure(
            state.order,
            rates: state.rates,
            isCardsAvailable: state.isCardsAvailable,
            exception: exception,
          ),
        );
      },
      onDone: () {
        emitter(OrderDetailState.idle(state.order, rates: state.rates, isCardsAvailable: state.isCardsAvailable));
      },
    );
  }

  Future<void> _changeAutoCharge(_OrderDetailChangeAutoCharge event, Emitter<OrderDetailState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        await _orderRepository.changeOrder(state.order!.id, isAutoCharge: event.isAutoCharge);
        add(const OrderDetailEvent.updateStatus());
      },
      onError: (exception, stackTrace) {
        emitter(
          OrderDetailState.failure(
            state.order,
            rates: state.rates,
            isCardsAvailable: state.isCardsAvailable,
            exception: exception,
          ),
        );
      },
      onDone: () {
        emitter(OrderDetailState.idle(state.order, rates: state.rates, isCardsAvailable: state.isCardsAvailable));
      },
    );
  }

  Future<void> _startListening(_OrderDetailStartListening event, Emitter<OrderDetailState> emitter) async {
    _statusSubscription = _statusStream.listen((_) => add(const OrderDetailEvent.updateStatus()));
    add(const OrderDetailEvent.updateStatus());
  }

  Future<void> _cancelListening(_OrderDetailCancelListening event, Emitter<OrderDetailState> emitter) async {
    await _statusSubscription?.cancel();
  }
}
