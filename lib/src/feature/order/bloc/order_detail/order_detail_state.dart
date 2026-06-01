part of 'order_detail_bloc.dart';

@Freezed()
sealed class const OrderDetailState._() with _$OrderDetailState {
  const factory idle(OrderDetail? order, {required List<RateData> rates, required bool isCardsAvailable}) =
      _OrderDetailIdle;

  const factory processing(
    OrderDetail? order, {
    required List<RateData> rates,
    required bool isCardsAvailable,
    @Default(false) bool isInitialProcessing,
  }) = _OrderDetailProcessing;

  const factory success(OrderDetail order, {required List<RateData> rates, required bool isCardsAvailable}) =
      _OrderDetailSuccess;

  const factory failure(
    OrderDetail? order, {
    required List<RateData> rates,
    required bool isCardsAvailable,
    required AppException exception,
  }) = _OrderDetailFailure;

  bool get inProgress => maybeMap(processing: (s) => !s.isInitialProcessing, orElse: () => false);

  bool get inInitialProgress => maybeMap(processing: (s) => s.isInitialProcessing, orElse: () => false);
}
