import 'package:bag24/src/core/utils/analytics/events/how_it_works_event.dart';
import 'package:bag24/src/core/utils/analytics/trackers/base_tracker.dart';

/// Tracker for "How It Works" page events
class HowItWorksTracker(super.analytics) extends BaseTracker {
  /// Send event when the "How It Works" page is opened
  Future<void> trackHowItWorksPageOpened() async {
    await analytics.logEvent(HowItWorksAnalyticsEvent.howItWorksPageOpened.value);
  }
}
