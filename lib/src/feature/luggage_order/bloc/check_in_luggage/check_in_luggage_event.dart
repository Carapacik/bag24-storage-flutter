part of 'check_in_luggage_bloc.dart';

@Freezed(copyWith: false)
sealed class CheckInLuggageEvent with _$CheckInLuggageEvent {
  const factory start() = _StartCheckInLuggageEvent;

  const factory shownPhotoRules() = _ShownPhotoRulesCheckInLuggageEvent;

  const factory create(List<LuggageItemModel> luggageList) = _CreateCheckInLuggageEvent;
}
