/// Events for photo addition
enum PhotoAnalyticsEvent() {
  /// Photo added from the gallery
  photoAddedFromGallery,

  /// Photo taken using the camera
  photoTakenWithCamera,
}

extension PhotoAnalyticsEventValues on PhotoAnalyticsEvent {
  String get value {
    switch (this) {
      case PhotoAnalyticsEvent.photoAddedFromGallery:
        return 'photo_added_from_gallery';
      case PhotoAnalyticsEvent.photoTakenWithCamera:
        return 'photo_taken_with_camera';
    }
  }
}
