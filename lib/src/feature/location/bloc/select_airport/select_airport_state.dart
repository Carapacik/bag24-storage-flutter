part of 'select_airport_bloc.dart';

@Freezed()
sealed class const SelectAirportState._() with _$SelectAirportState {
  const factory idle({
    required List<Location> locations,
    required List<Location> filteredLocations,
    required String searchQuery,
  }) = _SelectAirportIdle;

  const factory processing({
    required List<Location> locations,
    required List<Location> filteredLocations,
    required String searchQuery,
  }) = _SelectAirportProcessing;

  const factory success({
    required List<Location> locations,
    required List<Location> filteredLocations,
    required String searchQuery,
    Position? position,
  }) = _SelectAirportSuccess;

  const factory failure({
    required List<Location> locations,
    required List<Location> filteredLocations,
    required String searchQuery,
    required AppException exception,
  }) = _SelectAirportFailure;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);
}
