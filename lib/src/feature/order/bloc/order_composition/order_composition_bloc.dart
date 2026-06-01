import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/luggage_order/model/luggage_item_model.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'order_composition_bloc.freezed.dart';
part 'order_composition_event.dart';
part 'order_composition_state.dart';

final class OrderCompositionBloc({required final String _orderId, required final IOrderRepository _orderRepository})
    extends Bloc<OrderCompositionEvent, OrderCompositionState> {
  this : super(const OrderCompositionState.idle()) {
    on<_OrderCompositionAdd>(_add);
    on<_OrderCompositionEdit>(_edit);
    on<_OrderCompositionRemove>(_remove);
  }

  Future<void> _add(_OrderCompositionAdd event, Emitter<OrderCompositionState> emitter) async {
    emitter(const OrderCompositionState.processing());
    await ExceptionHandler.handle(
      () async {
        final String uploadedPhotoId = await _orderRepository.uploadPhoto(path: event.luggage.photo);
        await _orderRepository.addLuggage(
          _orderId,
          rateId: event.luggage.rateId,
          specialOfferId: event.luggage.specialOfferId,
          photoId: uploadedPhotoId,
        );
        emitter(const OrderCompositionState.success());
      },
      onError: (exception, stackTrace) => emitter(OrderCompositionState.failure(exception: exception)),
      onDone: () => emitter(const OrderCompositionState.idle()),
    );
  }

  Future<void> _edit(_OrderCompositionEdit event, Emitter<OrderCompositionState> emitter) async {
    emitter(const OrderCompositionState.processing());
    await ExceptionHandler.handle(
      () async {
        final LuggageItemModel luggage = event.luggage;
        var newPhotoId = '';
        if (Uuid.isValidUUID(fromString: luggage.photo)) {
          newPhotoId = luggage.photo;
        } else {
          newPhotoId = await _orderRepository.uploadPhoto(path: luggage.photo);
        }
        await _orderRepository.editLuggage(
          _orderId,
          luggageId: luggage.id ?? '',
          rateId: luggage.rateId,
          specialOfferId: luggage.specialOfferId,
          photoId: newPhotoId,
        );
        emitter(const OrderCompositionState.success());
      },
      onError: (exception, stackTrace) => emitter(OrderCompositionState.failure(exception: exception)),
      onDone: () => emitter(const OrderCompositionState.idle()),
    );
  }

  Future<void> _remove(_OrderCompositionRemove event, Emitter<OrderCompositionState> emitter) async {
    emitter(const OrderCompositionState.processing());
    await ExceptionHandler.handle(
      () async {
        await _orderRepository.deleteLuggage(_orderId, luggageId: event.id);
        emitter(const OrderCompositionState.success());
      },
      onError: (exception, stackTrace) => emitter(OrderCompositionState.failure(exception: exception)),
      onDone: () => emitter(const OrderCompositionState.idle()),
    );
  }
}
