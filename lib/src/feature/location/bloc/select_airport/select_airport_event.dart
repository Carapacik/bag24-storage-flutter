part of 'select_airport_bloc.dart';

@Freezed(copyWith: false)
sealed class SelectAirportEvent with _$SelectAirportEvent {
  const factory start() = _SelectAirportEventStart;

  const factory search(String searchQuery) = _SelectAirportEventSearch;
}
