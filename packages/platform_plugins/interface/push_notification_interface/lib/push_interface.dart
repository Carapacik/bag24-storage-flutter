abstract interface class IPushNotificationService() {
  Future<void> initialize(String environment);

  Stream<({String title, String body})> get messageStream;

  Future<String?> getToken();

  Future<void> subscribeToTopic(String topic);

  Future<void> unsubscribeFromTopic(String topic);

  Future<void> registerMessageCallback();

  Future<void> registerMessageOpenedAppCallback();
}
