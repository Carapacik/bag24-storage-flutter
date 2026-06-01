part of 'onboarding_bloc.dart';

@Freezed(copyWith: false)
sealed class OnboardingEvent with _$OnboardingEvent {
  const factory setHideOnboarding() = _SetHideOnboarding;
}
