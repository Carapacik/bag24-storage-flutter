part of 'order_created_bloc.dart';

@Freezed()
sealed class const OrderCreatedState._() with _$OrderCreatedState {
  const factory idle(OrderDetail? order) = _OrderCreatedStateIdle;

  const factory processing(OrderDetail? order) = _OrderCreatedStateProcessing;

  const factory success(OrderDetail? order) = _OrderCreatedStateSuccess;

  const factory failure(OrderDetail? order, {required AppException exception}) = _OrderCreatedStateFailure;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);
}
