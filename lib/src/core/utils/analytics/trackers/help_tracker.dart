import 'package:bag24/src/core/utils/analytics/events/help_event.dart';
import 'package:bag24/src/core/utils/analytics/trackers/base_tracker.dart';

/// Tracker for help page events
class HelpPageTracker(super.analytics) extends BaseTracker {
  /// Send event when the help page is opened
  Future<void> trackHelpPageOpened() async {
    await analytics.logEvent(HelpPageAnalyticsEvent.helpPageOpened.value);
  }

  /// Send event when a specific help topic is selected
  Future<void> trackHelpTopicSelected(String topic) async {
    await analytics.logEvent(HelpPageAnalyticsEvent.helpTopicSelected.value, params: {'topic': topic});
  }
}
