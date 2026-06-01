part of 'order_composition_bloc.dart';

@Freezed()
sealed class const OrderCompositionState._() with _$OrderCompositionState {
  const factory idle() = _OrderCompositionIdle;

  const factory processing() = _OrderCompositionProcessing;

  const factory success() = _OrderCompositionSuccess;

  const factory failure({required AppException exception}) = _OrderCompositioneFailure;
}
