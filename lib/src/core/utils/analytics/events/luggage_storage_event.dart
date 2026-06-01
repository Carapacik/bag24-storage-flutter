/// Luggage storage events
enum LuggageStorageAnalyticsEvent() {
  /// Luggage storage page opened
  luggageStorageOpened,

  /// User selected luggage storage
  luggageStorageSelected,

  /// Luggage storage booking
  luggageStorageBooking,
}

extension LuggageStorageAnalyticsEventValues on LuggageStorageAnalyticsEvent {
  String get value {
    switch (this) {
      case LuggageStorageAnalyticsEvent.luggageStorageOpened:
        return 'luggage_storage_opened';
      case LuggageStorageAnalyticsEvent.luggageStorageSelected:
        return 'luggage_storage_selected';
      case LuggageStorageAnalyticsEvent.luggageStorageBooking:
        return 'luggage_storage_booking';
    }
  }
}
