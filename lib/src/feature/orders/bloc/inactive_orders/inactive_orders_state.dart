part of 'inactive_orders_bloc.dart';

@Freezed()
sealed class const InactiveOrdersState._() with _$InactiveOrdersState {
  const factory idle(List<OrderItem> orders, {required bool hasReachedMax}) = _InactiveOrdersIdle;

  const factory processing(List<OrderItem> orders, {required bool hasReachedMax}) = _InactiveOrdersProcessing;

  const factory fetching(List<OrderItem> orders, {required bool hasReachedMax}) = _InactiveOrdersFetching;

  const factory success(List<OrderItem> orders, {required bool hasReachedMax}) = _InactiveOrdersSuccess;

  const factory failure(List<OrderItem> orders, {required bool hasReachedMax, required AppException exception}) =
      _InactiveOrdersFailure;

  const factory fetchingFailure(
    List<OrderItem> orders, {
    required bool hasReachedMax,
    required AppException exception,
  }) = _InactiveOrdersFetchingFailure;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);

  bool get isFailure => maybeMap(failure: (_) => true, orElse: () => false);

  bool get isFetchFailure => maybeMap(fetchingFailure: (_) => true, orElse: () => false);
}
