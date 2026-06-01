import 'package:bag24/src/core/utils/analytics/events/storage_conditions_event.dart';
import 'package:bag24/src/core/utils/analytics/trackers/base_tracker.dart';

/// Tracker for storage conditions page events
class StorageConditionsTracker(super.analytics) extends BaseTracker {
  /// Send event when the storage conditions page is opened
  Future<void> trackStorageConditionsPageOpened() async {
    await analytics.logEvent(StorageConditionsAnalyticsEvent.storageConditionsPageOpened.value);
  }
}
