/// Events for "How It Works" page
enum HowItWorksAnalyticsEvent() {
  /// "How It Works" page opened
  howItWorksPageOpened,

  /// Section of "How It Works" page viewed
  howItWorksSectionViewed,
}

extension HowItWorksAnalyticsEventValues on HowItWorksAnalyticsEvent {
  String get value {
    switch (this) {
      case HowItWorksAnalyticsEvent.howItWorksPageOpened:
        return 'how_it_works_page_opened';
      case HowItWorksAnalyticsEvent.howItWorksSectionViewed:
        return 'how_it_works_section_viewed';
    }
  }
}
