import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/authentication/data/authentication_repository.dart';
import 'package:bag24/src/feature/location/data/storage_repository.dart';
import 'package:bag24/src/feature/location/model/storage_model.dart';
import 'package:bag24/src/feature/luggage_order/model/luggage_item_model.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_in_luggage_bloc.freezed.dart';
part 'check_in_luggage_event.dart';
part 'check_in_luggage_state.dart';

final class CheckInLuggageBloc({
  required final String _storageId,
  required final IAuthenticationRepository _authenticationRepository,
  required final IOrderRepository _orderRepository,
  required final IStorageRepository _storageRepository,
}) extends Bloc<CheckInLuggageEvent, CheckInLuggageState> {
  this : super(const CheckInLuggageState.processing(null, isShownPhotoRules: false)) {
    on<_StartCheckInLuggageEvent>(_start);
    on<_ShownPhotoRulesCheckInLuggageEvent>(_shownPhotoRules);
    on<_CreateCheckInLuggageEvent>(_create);

    add(const CheckInLuggageEvent.start());
  }

  Future<void> _start(_StartCheckInLuggageEvent event, Emitter<CheckInLuggageState> emitter) async {
    emitter(const CheckInLuggageState.processing(null, isShownPhotoRules: false));
    await ExceptionHandler.handle(
      () async {
        final bool isShownPhotoRules = await _orderRepository.isShownPhotoRules;
        final Storage storage = await _storageRepository.getStorageById(_storageId);
        emitter(CheckInLuggageState.idle(storage, isShownPhotoRules: isShownPhotoRules));
      },
      onError: (exception, stackTrace) {
        emitter(
          CheckInLuggageState.failure(state.storage, isShownPhotoRules: state.isShownPhotoRules, exception: exception),
        );
      },
      onDone: () {
        emitter(CheckInLuggageState.idle(state.storage, isShownPhotoRules: state.isShownPhotoRules));
      },
    );
  }

  Future<void> _shownPhotoRules(_ShownPhotoRulesCheckInLuggageEvent event, Emitter<CheckInLuggageState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        await _orderRepository.setPhotoRulesShown();
        emitter(CheckInLuggageState.idle(state.storage, isShownPhotoRules: true));
      },
      onError: (exception, stackTrace) {
        emitter(
          CheckInLuggageState.failure(state.storage, isShownPhotoRules: state.isShownPhotoRules, exception: exception),
        );
      },
      onDone: () {
        emitter(CheckInLuggageState.idle(state.storage, isShownPhotoRules: state.isShownPhotoRules));
      },
    );
  }

  Future<void> _create(_CreateCheckInLuggageEvent event, Emitter<CheckInLuggageState> emitter) async {
    emitter(CheckInLuggageState.processing(state.storage, isShownPhotoRules: state.isShownPhotoRules));
    final List<LuggageItemModel> luggageList = event.luggageList;
    var photoIds = <String>[];
    // send photos and get ids
    await ExceptionHandler.handle(
      () async {
        final Iterable<Future<String>> uploadPhotoFutures = luggageList
            .map((e) => e.photo)
            .map((photo) => _orderRepository.uploadPhoto(path: photo));

        // refresh before multiple requests
        await _authenticationRepository.refreshUser();

        photoIds = await Future.wait(uploadPhotoFutures);
      },
      onError: (exception, stackTrace) async {
        emitter(
          CheckInLuggageState.failure(state.storage, isShownPhotoRules: state.isShownPhotoRules, exception: exception),
        );
      },
    );
    await ExceptionHandler.handle(
      () async {
        final String orderId = await _orderRepository.createOrder(_storageId, photoIds, luggageList);
        emitter(
          CheckInLuggageState.success(state.storage, isShownPhotoRules: state.isShownPhotoRules, orderId: orderId),
        );
      },
      onError: (exception, stackTrace) {
        emitter(
          CheckInLuggageState.failure(state.storage, isShownPhotoRules: state.isShownPhotoRules, exception: exception),
        );
      },
      onDone: () {
        emitter(CheckInLuggageState.idle(state.storage, isShownPhotoRules: state.isShownPhotoRules));
      },
    );
  }
}
