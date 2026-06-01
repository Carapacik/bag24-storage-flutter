part of 'active_orders_bloc.dart';

@Freezed(copyWith: false)
sealed class ActiveOrdersEvent with _$ActiveOrdersEvent {
  const factory start() = _ActiveOrdersStarted;

  const factory fetched() = _ActiveOrdersStartedFetched;
}
