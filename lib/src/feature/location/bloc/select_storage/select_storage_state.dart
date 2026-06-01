part of 'select_storage_bloc.dart';

@Freezed()
sealed class const SelectStorageState._() with _$SelectStorageState {
  const factory idle({
    required List<Storage> storages,
    required String searchQuery,
    Position? position,
    @Default(false) bool hasReachedMax,
  }) = _SelectStorageIdle;

  const factory processing({
    required List<Storage> storages,
    required String searchQuery,
    Position? position,
    @Default(false) bool hasReachedMax,
  }) = _SelectStorageProcessing;

  const factory fetching({
    required List<Storage> storages,
    required String searchQuery,
    Position? position,
    @Default(false) bool hasReachedMax,
  }) = _SelectStorageFetching;

  const factory success({
    required List<Storage> storages,
    required String searchQuery,
    Position? position,
    @Default(false) bool hasReachedMax,
  }) = _SelectStorageSuccess;

  const factory failure({
    required List<Storage> storages,
    required String searchQuery,
    required AppException exception,
    Position? position,
    @Default(false) bool hasReachedMax,
  }) = _SelectStorageFailure;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);
}
