import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationManager() {
  static const _channelIdPush = 'push';

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidInitializationSettings = AndroidInitializationSettings('ic_bg_service_small');
    const iOSInitializationSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) async {
        // logger.info('Payload of notification: ${notificationResponse.payload}');
      },
    );
  }

  Future<void> showNotification(String title, String body, {String? payload}) async {
    await _notificationsPlugin.show(
      id: 90,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
        android: AndroidNotificationDetails(
          _channelIdPush,
          'PushNotification',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: payload,
    );
  }
}
