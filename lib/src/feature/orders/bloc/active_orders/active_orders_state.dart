part of 'active_orders_bloc.dart';

@Freezed()
sealed class const ActiveOrdersState._() with _$ActiveOrdersState {
  const factory idle(List<OrderItem> orders, {required bool hasReachedMax}) = _ActiveOrdersIdle;

  const factory processing(List<OrderItem> orders, {required bool hasReachedMax}) = _ActiveOrdersProcessing;

  const factory fetching(List<OrderItem> orders, {required bool hasReachedMax}) = _ActiveOrdersFetching;

  const factory success(List<OrderItem> orders, {required bool hasReachedMax}) = _ActiveOrdersSuccess;

  const factory failure(List<OrderItem> orders, {required bool hasReachedMax, required AppException exception}) =
      _ActiveOrdersFailure;

  const factory fetchingFailure(
    List<OrderItem> orders, {
    required bool hasReachedMax,
    required AppException exception,
  }) = _ActiveOrdersFetchingFailure;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);

  bool get isFailure => maybeMap(failure: (_) => true, orElse: () => false);

  bool get isFetchFailure => maybeMap(fetchingFailure: (_) => true, orElse: () => false);
}
