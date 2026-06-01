import 'package:bag24/src/feature/onboarding/data/onboarding_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_bloc.freezed.dart';
part 'onboarding_event.dart';
part 'onboarding_state.dart';

final class OnboardingBloc({required final IOnboardingRepository _onboardingRepository})
    extends Bloc<OnboardingEvent, OnboardingState> {
  this : super(const OnboardingState.idle()) {
    on<_SetHideOnboarding>(_setHideOnboarding);
  }

  Future<void> _setHideOnboarding(_SetHideOnboarding event, Emitter<OnboardingState> emitter) async =>
      await _onboardingRepository.setHideOnboarding();
}
