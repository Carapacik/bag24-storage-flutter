/// Events for storage conditions page
enum StorageConditionsAnalyticsEvent() {
  /// Storage conditions page opened
  storageConditionsPageOpened,
}

extension StorageConditionsAnalyticsEventValues on StorageConditionsAnalyticsEvent {
  String get value {
    switch (this) {
      case StorageConditionsAnalyticsEvent.storageConditionsPageOpened:
        return 'storage_conditions_page_opened';
    }
  }
}
