import 'package:bag24/src/core/utils/analytics/events/onboarding_event.dart';
import 'package:bag24/src/core/utils/analytics/trackers/base_tracker.dart';
import 'package:bag24/src/feature/onboarding/model/onboarding_progress.dart';

/// Трекер собыий онбординга
class OnboardingTracker(super.analytics) extends BaseTracker {
  /// Отправить событие запуска онбординга
  Future<void> trackOnboardingOpened() async {
    await analytics.logEvent(OnboardingAnalyticsEvent.onboardingOpened.value);
  }

  /// Отправить событие завершения онбординга
  Future<void> trackOnboardingFinished(OnboardingProgress type) async =>
      await analytics.logEvent(OnboardingAnalyticsEvent.onboardingFinished.value, params: {'type': type.name});
}
