import 'package:bag24/src/feature/location/model/location_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rest_client/locations/locations_client.dart';

abstract interface class ILocationRepository() {
  Future<List<Location>> getLocations({Position? currentPosition});
}

class const LocationRepository({required final LocationsClient _locationsClient}) implements ILocationRepository {
  @override
  Future<List<Location>> getLocations({Position? currentPosition}) async => await _locationsClient
      .getLocations(tags: ['STORAGE'], lat: currentPosition?.latitude, lon: currentPosition?.longitude)
      .then((dto) => dto.result.locations.map(Location.decode).toList());
}
