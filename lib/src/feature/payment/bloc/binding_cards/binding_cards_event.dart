part of 'binding_cards_bloc.dart';

@Freezed(copyWith: false)
sealed class BindingCardsEvent with _$BindingCardsEvent {
  const factory start() = _BindingCardsEventStart;

  const factory removeCard(String cardId) = _BindingCardsEventRemoveCard;
}
