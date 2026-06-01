import 'package:bag24/src/core/utils/analytics/events/order_canceled_event.dart';
import 'package:bag24/src/core/utils/analytics/trackers/base_tracker.dart';

/// Tracker for order canceled events
class OrderCanceledTracker(super.analytics) extends BaseTracker {
  /// Send event when a order is canceled
  Future<void> orderCanceled(String reason) async {
    await analytics.logEvent(OrderCanceledAnalyticsEvent.orderCanceled.value, params: {'reason': reason});
  }
}
