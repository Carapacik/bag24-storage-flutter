import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:huawei_push/huawei_push.dart';
import 'package:push_notification_interface/push_interface.dart';

class PushNotificationService implements IPushNotificationService {
  PushNotificationService();

  late final StreamController<({String title, String body})> _messageController;

  @override
  Future<void> initialize(String environment) async {
    _messageController = StreamController<({String title, String body})>.broadcast();
    Push.getTokenStream.listen((token) {
      _log('New token: $token');
      // Handle token refresh here if needed
    });

    final token = await getToken();
    if (token != null) {
      _log('Huawei Push Token: $token');
    } else {
      _log('Failed to get Huawei Push token');
    }
  }

  @override
  Stream<({String title, String body})> get messageStream => _messageController.stream;

  @override
  Future<String?> getToken() async {
    try {
      Push.getToken('HCM');
      await for (final token in Push.getTokenStream) {
        if (token.isNotEmpty) {
          return token;
        }
      }
    } on Object catch (e) {
      _log('Error getting Huawei Push token: $e');
      return null;
    }
    return null;
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    try {
      final result = await Push.subscribe(topic);
      _log('Subscribed to topic: $topic, result: $result');
    } on Object catch (e) {
      _log('Error subscribing to topic [$topic]: $e');
    }
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      final result = await Push.unsubscribe(topic);
      _log('Unsubscribed from topic: $topic, result: $result');
    } on Object catch (e) {
      _log('Error unsubscribing from topic [$topic]: $e');
    }
  }

  @override
  Future<void> registerMessageCallback() async {
    Push.onMessageReceivedStream.listen((message) async {
      final notification = message.notification;
      if (notification != null) {
        _log(
          'Notification title: ${notification.title}'
          'Notification body: ${notification.body}',
        );
        _messageController.add((title: notification.title ?? '', body: notification.body ?? ''));
      }
    });
  }

  @override
  Future<void> registerMessageOpenedAppCallback() async {
    Push.onNotificationOpenedApp.listen((event) async {
      final message = Map<String, dynamic>.from(event as Map<String, dynamic>);
      final notification = message['notification'] as Map<String, dynamic>?;
      if (notification != null) {
        final title = notification['title'] as String?;
        final body = notification['body'] as String?;
        _log(
          'Notification title: $title'
          'Notification body: $body',
        );

        if (title != null && body != null) {
          _messageController.add((title: title, body: body));
        }
      }
    });
  }

  void _log(String message) {
    if (kDebugMode) {
      developer.log(message, name: '[HuaweiPushMessage]');
    }
  }
}
