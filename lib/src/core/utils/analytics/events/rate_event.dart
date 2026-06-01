/// Events for rate selection
enum RateAnalyticsEvent() {
  /// Rate window opened
  rateOpened,

  /// Rate selected
  rateSelected,
}

extension RateAnalyticsEventValues on RateAnalyticsEvent {
  String get value {
    switch (this) {
      case RateAnalyticsEvent.rateOpened:
        return 'rate_opened';
      case RateAnalyticsEvent.rateSelected:
        return 'rate_selected';
    }
  }
}
