part of 'inactive_orders_bloc.dart';

@Freezed(copyWith: false)
sealed class InactiveOrdersEvent with _$InactiveOrdersEvent {
  const factory start() = _InactiveOrdersStarted;

  const factory fetched() = _InactiveOrdersFetched;
}
