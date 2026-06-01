part of 'order_created_bloc.dart';

@Freezed(copyWith: false)
sealed class OrderCreatedEvent with _$OrderCreatedEvent {
  const factory start() = _StartOrderCreatedEvent;
}
