import 'package:bag24/src/core/utils/analytics/events/rate_event.dart';
import 'package:bag24/src/core/utils/analytics/trackers/base_tracker.dart';
import 'package:bag24/src/feature/luggage_order/model/rate_data.dart';

/// Tracker for rate selection
class RateTracker(super.analytics) extends BaseTracker {
  /// Send event when the rate window is opened
  Future<void> trackRateOpened() async {
    await analytics.logEvent(RateAnalyticsEvent.rateOpened.value);
  }

  /// Send event when a rate is selected
  Future<void> trackRateSelected(RateData rate) async {
    await analytics.logEvent(RateAnalyticsEvent.rateSelected.value, params: {'id': rate.id, 'title': rate.title});
  }
}
