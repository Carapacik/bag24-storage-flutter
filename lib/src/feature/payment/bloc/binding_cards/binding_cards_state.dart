part of 'binding_cards_bloc.dart';

@Freezed()
sealed class const BindingCardsState._() with _$BindingCardsState {
  const factory idle({required List<BindingModel> cards}) = _BindingCardsStateIdle;

  const factory processing({required List<BindingModel> cards}) = _BindingCardsStateProcessing;

  const factory success({required List<BindingModel> cards, @Default(false) bool isCardRemoved}) =
      _BindingCardsStateSuccess;

  const factory failure({required List<BindingModel> cards, required AppException exception}) =
      _BindingCardsStateFailure;
}
