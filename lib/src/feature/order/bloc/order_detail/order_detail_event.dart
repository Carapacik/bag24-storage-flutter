part of 'order_detail_bloc.dart';

@Freezed(copyWith: false)
sealed class OrderDetailEvent with _$OrderDetailEvent {
  const factory start() = _OrderDetailStarted;

  const factory updateStatus({@Default(false) bool updateComposition}) = _OrderDetailUpdateStatus;

  const factory changeAutoCharge({required bool isAutoCharge}) = _OrderDetailChangeAutoCharge;

  const factory startListening() = _OrderDetailStartListening;

  const factory cancelListening() = _OrderDetailCancelListening;
}
