import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bag24/src/core/utils/analytics/analytics.dart';
import 'package:bag24/src/core/utils/analytics/services/appmetrica_analytics_service.dart';
import 'package:bag24/src/core/utils/analytics/trackers/help_tracker.dart';
import 'package:bag24/src/core/utils/analytics/trackers/how_it_works_tracker.dart';
import 'package:bag24/src/core/utils/analytics/trackers/luggage_storage_tracker.dart';
import 'package:bag24/src/core/utils/analytics/trackers/onboarding_tracker.dart';
import 'package:bag24/src/core/utils/analytics/trackers/order_canceled_tracker.dart';
import 'package:bag24/src/core/utils/analytics/trackers/photo_tracker.dart';
import 'package:bag24/src/core/utils/analytics/trackers/rate_select_tracker.dart';
import 'package:bag24/src/core/utils/analytics/trackers/storage_conditions_tracker.dart';

/// Interactor for working with analytics
class AnalyticsInteractor() {
  /// Tracker for sending onboarding events [OnboardingTracker]
  late final onboardingTracker = OnboardingTracker(_analytics);

  /// Tracker for sending rate events [RateTracker]
  late final rateTracker = RateTracker(_analytics);

  /// Tracker for sending luggage storage events [LuggageStorageTracker]
  late final luggageStorageTracker = LuggageStorageTracker(_analytics);

  /// Tracker for sending help page events [HelpPageTracker]
  late final helpPageTracker = HelpPageTracker(_analytics);

  /// Tracker for sending "How It Works" page events [HowItWorksTracker]
  late final howItWorksTracker = HowItWorksTracker(_analytics);

  /// Tracker for sending storage conditions page events [StorageConditionsTracker]
  late final storageConditionsTracker = StorageConditionsTracker(_analytics);

  /// Tracker for sending photo addition events [PhotoTracker]
  late final photoTracker = PhotoTracker(_analytics);

  /// Tracker for order canceled events [OrderCanceledTracker]
  late final orderCanceledTracker = OrderCanceledTracker(_analytics);

  Future<void> initialize({required String appMetricaKey}) async {
    await AppMetrica.activate(AppMetricaConfig(appMetricaKey));
  }

  Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(userId);
  }

  final _analytics = Analytics([
    /// When adding a new analytics service for the same events,
    /// simply add it here
    // FirebaseAnalyticsService(),
    AppMetricaAnalyticsService(),
  ]);
}
