part of 'order_composition_bloc.dart';

@Freezed(copyWith: false)
sealed class OrderCompositionEvent with _$OrderCompositionEvent {
  const factory add(LuggageItemModel luggage) = _OrderCompositionAdd;

  const factory edit(LuggageItemModel luggage) = _OrderCompositionEdit;

  const factory remove(String id) = _OrderCompositionRemove;
}
