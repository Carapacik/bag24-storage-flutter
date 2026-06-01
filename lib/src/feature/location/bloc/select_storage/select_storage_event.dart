part of 'select_storage_bloc.dart';

@Freezed(copyWith: false)
sealed class SelectStorageEvent with _$SelectStorageEvent {
  const factory start() = _SelectStorageEventStart;

  const factory fetched() = _SelectStorageEventFetched;

  const factory search(String searchQuery) = _SelectStorageEventSearch;
}
