import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/core/utils/bloc_transformer.dart';
import 'package:bag24/src/feature/location/data/geolocation_repository.dart';
import 'package:bag24/src/feature/location/data/location_repository.dart';
import 'package:bag24/src/feature/location/model/location_model.dart';
import 'package:bag24/src/feature/permissions/data/permissions_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'select_airport_bloc.freezed.dart';
part 'select_airport_event.dart';
part 'select_airport_state.dart';

final class SelectAirportBloc({
  required final IGeolocationRepository _geolocationRepository,
  required final ILocationRepository _locationRepository,
  required final IPermissionsRepository _permissionsRepository,
}) extends Bloc<SelectAirportEvent, SelectAirportState> {
  this : super(const SelectAirportState.processing(locations: [], filteredLocations: [], searchQuery: '')) {
    on<_SelectAirportEventStart>(_start);
    on<_SelectAirportEventSearch>(
      _search,
      transformer: DenounceRestartableBlocTransformer<_SelectAirportEventSearch>().transform,
    );
  }

  Future<void> _start(_SelectAirportEventStart event, Emitter<SelectAirportState> emitter) async {
    emitter(const SelectAirportState.processing(locations: [], filteredLocations: [], searchQuery: ''));
    await ExceptionHandler.handle(
      () async {
        await _geolocationRepository.requestPermission();
        final bool isLocationGranted = await _permissionsRepository.checkLocationPermission();
        Position? currentPosition;
        if (isLocationGranted) {
          currentPosition = await _geolocationRepository.getCurrentPosition();
        }
        final List<Location> locations = await _locationRepository.getLocations(currentPosition: currentPosition);
        emitter(
          SelectAirportState.success(
            locations: locations,
            filteredLocations: state.filteredLocations,
            searchQuery: state.searchQuery,
            position: currentPosition,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        SelectAirportState.failure(
          locations: state.locations,
          filteredLocations: state.filteredLocations,
          searchQuery: state.searchQuery,
          exception: exception,
        ),
      ),
      onDone: () => emitter(
        SelectAirportState.idle(
          locations: state.locations,
          filteredLocations: state.filteredLocations,
          searchQuery: state.searchQuery,
        ),
      ),
    );
  }

  Future<void> _search(_SelectAirportEventSearch event, Emitter<SelectAirportState> emitter) async {
    final String searchQuery = event.searchQuery.trim().toLowerCase();
    emitter(
      SelectAirportState.processing(
        locations: state.locations,
        filteredLocations: state.filteredLocations,
        searchQuery: searchQuery,
      ),
    );
    List<Location> filterLocations(String searchQuery) => state.locations
        .where(
          (location) =>
              location.name.toLowerCase().contains(searchQuery) ||
              location.shortName.toLowerCase().contains(searchQuery) ||
              location.city.toLowerCase().contains(searchQuery),
        )
        .toList();

    final List<Location> filteredLocations = filterLocations(searchQuery);

    emitter(
      SelectAirportState.idle(
        locations: state.locations,
        filteredLocations: filteredLocations,
        searchQuery: state.searchQuery,
      ),
    );
  }
}
