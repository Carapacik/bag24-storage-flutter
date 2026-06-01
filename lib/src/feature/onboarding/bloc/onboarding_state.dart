part of 'onboarding_bloc.dart';

@Freezed()
sealed class const OnboardingState._() with _$OnboardingState {
  const factory idle() = _OnboardingIdle;

  const factory processing() = _OnboardingProcessing;

  const factory success() = _OnboardingSuccess;

  const factory failure() = _OnboardingFailure;
}
