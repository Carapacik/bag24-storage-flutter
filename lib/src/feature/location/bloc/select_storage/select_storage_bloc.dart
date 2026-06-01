import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/core/utils/bloc_transformer.dart';
import 'package:bag24/src/feature/location/data/geolocation_repository.dart';
import 'package:bag24/src/feature/location/data/storage_repository.dart';
import 'package:bag24/src/feature/location/model/storage_model.dart';
import 'package:bag24/src/feature/permissions/data/permissions_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'select_storage_bloc.freezed.dart';
part 'select_storage_event.dart';
part 'select_storage_state.dart';

final class SelectStorageBloc({
  required final IGeolocationRepository _geolocationRepository,
  required final IStorageRepository _storageRepository,
  required final IPermissionsRepository _permissionsRepository,
}) extends Bloc<SelectStorageEvent, SelectStorageState> {
  this : super(const SelectStorageState.processing(storages: [], searchQuery: '')) {
    on<_SelectStorageEventStart>(_start);
    on<_SelectStorageEventSearch>(
      _search,
      transformer: DenounceRestartableBlocTransformer<_SelectStorageEventSearch>().transform,
    );
    on<_SelectStorageEventFetched>(
      _fetched,
      transformer: ThrottleDroppableBlocTransformer<_SelectStorageEventFetched>().transform,
    );
  }

  static const _limit = 20;

  Future<void> _start(_SelectStorageEventStart event, Emitter<SelectStorageState> emitter) async {
    emitter(const SelectStorageState.processing(storages: [], searchQuery: ''));
    await ExceptionHandler.handle(
      () async {
        await _geolocationRepository.requestPermission();
        final bool isLocationGranted = await _permissionsRepository.checkLocationPermission();
        Position? currentPosition;
        if (isLocationGranted) {
          currentPosition = await _geolocationRepository.getCurrentPosition();
        }
        final List<Storage> storages = await _storageRepository.getStorages(position: currentPosition);
        emitter(
          SelectStorageState.success(
            storages: List.of(storages),
            searchQuery: state.searchQuery,
            position: currentPosition,
            hasReachedMax: storages.isEmpty || storages.length < _limit,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        SelectStorageState.failure(
          storages: state.storages,
          searchQuery: state.searchQuery,
          position: state.position,
          hasReachedMax: state.hasReachedMax,
          exception: exception,
        ),
      ),
      onDone: () => emitter(
        SelectStorageState.idle(
          storages: state.storages,
          searchQuery: state.searchQuery,
          position: state.position,
          hasReachedMax: state.hasReachedMax,
        ),
      ),
    );
  }

  Future<void> _fetched(_SelectStorageEventFetched event, Emitter<SelectStorageState> emitter) async {
    if (state.hasReachedMax) {
      return;
    }
    emitter(
      SelectStorageState.fetching(
        storages: state.storages,
        searchQuery: state.searchQuery,
        position: state.position,
        hasReachedMax: state.hasReachedMax,
      ),
    );
    await ExceptionHandler.handle(
      () async {
        final List<Storage> storages = await _storageRepository.getStorages(
          position: state.position,
          offset: state.storages.length,
          searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
        );
        emitter(
          SelectStorageState.success(
            storages: List.of(state.storages)..addAll(storages),
            searchQuery: state.searchQuery,
            position: state.position,
            hasReachedMax: storages.isEmpty,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        SelectStorageState.failure(
          storages: state.storages,
          searchQuery: state.searchQuery,
          position: state.position,
          hasReachedMax: state.hasReachedMax,
          exception: exception,
        ),
      ),
      onDone: () => emitter(
        SelectStorageState.idle(
          storages: state.storages,
          searchQuery: state.searchQuery,
          position: state.position,
          hasReachedMax: state.hasReachedMax,
        ),
      ),
    );
  }

  Future<void> _search(_SelectStorageEventSearch event, Emitter<SelectStorageState> emitter) async {
    final String searchQuery = event.searchQuery.trim().toLowerCase();
    emitter(
      SelectStorageState.processing(storages: state.storages, searchQuery: searchQuery, position: state.position),
    );
    await ExceptionHandler.handle(
      () async {
        final List<Storage> storages = await _storageRepository.getStorages(
          position: state.position,
          searchQuery: searchQuery,
        );
        emitter(
          SelectStorageState.success(
            storages: storages,
            searchQuery: state.searchQuery,
            position: state.position,
            hasReachedMax: storages.isEmpty,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        SelectStorageState.failure(
          storages: state.storages,
          searchQuery: state.searchQuery,
          position: state.position,
          hasReachedMax: state.hasReachedMax,
          exception: exception,
        ),
      ),
      onDone: () => emitter(
        SelectStorageState.idle(
          storages: state.storages,
          searchQuery: state.searchQuery,
          position: state.position,
          hasReachedMax: state.hasReachedMax,
        ),
      ),
    );
  }
}
