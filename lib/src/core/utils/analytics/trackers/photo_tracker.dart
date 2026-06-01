import 'package:bag24/src/core/utils/analytics/events/photo_event.dart';
import 'package:bag24/src/core/utils/analytics/trackers/base_tracker.dart';

/// Tracker for photo addition events
class PhotoTracker(super.analytics) extends BaseTracker {
  /// Send event when a photo is added from the gallery
  Future<void> trackPhotoAddedFromGallery() async {
    await analytics.logEvent(PhotoAnalyticsEvent.photoAddedFromGallery.value);
  }

  /// Send event when a photo is taken using the camera
  Future<void> trackPhotoTakenWithCamera() async {
    await analytics.logEvent(PhotoAnalyticsEvent.photoTakenWithCamera.value);
  }
}
