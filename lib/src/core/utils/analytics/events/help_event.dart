/// Events for help page
enum HelpPageAnalyticsEvent() {
  /// Help page opened
  helpPageOpened,

  /// Help topic selected
  helpTopicSelected,
}

extension HelpPageAnalyticsEventValues on HelpPageAnalyticsEvent {
  String get value {
    switch (this) {
      case HelpPageAnalyticsEvent.helpPageOpened:
        return 'help_page_opened';
      case HelpPageAnalyticsEvent.helpTopicSelected:
        return 'help_topic_selected';
    }
  }
}
