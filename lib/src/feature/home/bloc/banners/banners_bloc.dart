import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/home/data/home_repository.dart';
import 'package:bag24/src/feature/home/model/banner_data.dart';
import 'package:bag24/src/feature/location/data/geolocation_repository.dart';
import 'package:bag24/src/feature/location/data/storage_repository.dart';
import 'package:bag24/src/feature/location/model/storage_model.dart';
import 'package:bag24/src/feature/permissions/data/permissions_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'banners_bloc.freezed.dart';
part 'banners_event.dart';
part 'banners_state.dart';

final class BannersBloc({
  required final IHomeRepository _homeRepository,
  required final IPermissionsRepository _permissionsRepository,
  required final IStorageRepository _storageRepository,
  required final IGeolocationRepository _geolocationRepository,
}) extends Bloc<BannersEvent, BannersState> {
  this : super(const BannersState.processing(banners: [])) {
    on<_BannersStarted>(_start);
    on<_BannersUpdateBookBanner>(_updateBookBanner);

    add(const BannersEvent.start());
  }

  Future<void> _start(_BannersStarted event, Emitter<BannersState> emitter) async {
    emitter(BannersState.processing(banners: state.banners));
    await ExceptionHandler.handle(
      () async {
        final List<BannerData> banners = await _homeRepository.banners;
        final bool? isLocationGranted = await _permissionsRepository.isLocationEnabled;
        Storage? nearestStorage;
        if (isLocationGranted ?? false) {
          final Position currentPosition = await _geolocationRepository.getCurrentPosition();
          final List<Storage> storages = await _storageRepository.getStorages(limit: 1, position: currentPosition);
          nearestStorage = storages.firstOrNull;
        }
        emitter(BannersState.success(banners: banners, nearestStorage: nearestStorage));
      },
      onError: (exception, stackTrace) => emitter(
        BannersState.failure(banners: state.banners, nearestStorage: state.nearestStorage, exception: exception),
      ),
      onDone: () => emitter(BannersState.idle(banners: state.banners, nearestStorage: state.nearestStorage)),
    );
  }

  Future<void> _updateBookBanner(_BannersUpdateBookBanner event, Emitter<BannersState> emitter) async {
    emitter(BannersState.processing(banners: state.banners));
    await ExceptionHandler.handle(
      () async {
        final bool? isLocationGranted = await _permissionsRepository.isLocationEnabled;
        Storage? nearestStorage;
        if (isLocationGranted ?? false) {
          final List<Storage> storages = await _storageRepository.getStorages(limit: 1, position: event.position);
          nearestStorage = storages.firstOrNull;
        }
        emitter(BannersState.success(banners: state.banners, nearestStorage: nearestStorage));
      },
      onError: (exception, stackTrace) => emitter(
        BannersState.failure(banners: state.banners, nearestStorage: state.nearestStorage, exception: exception),
      ),
      onDone: () => emitter(BannersState.idle(banners: state.banners, nearestStorage: state.nearestStorage)),
    );
  }
}
