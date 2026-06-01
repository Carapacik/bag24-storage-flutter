import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:push_notification_interface/push_interface.dart';
import 'package:push_notification_service/options/firebase_options.dev.dart' as dev;
import 'package:push_notification_service/options/firebase_options.prod.dart' as prod;
import 'package:push_notification_service/options/firebase_options.stage.dart' as stage;

class PushNotificationService() implements IPushNotificationService {
  late final StreamController<({String title, String body})> _messageController;
  late final FirebaseMessaging _firebaseMessaging;

  @override
  Future<void> initialize(String environment) async {
    await _initializeFirebase(environment);

    _messageController = StreamController<({String title, String body})>.broadcast();
    _firebaseMessaging = FirebaseMessaging.instance;

    _firebaseMessaging.onTokenRefresh.listen((token) {
      _log('New token: $token');
      // Handle token refresh here if needed
    });

    // Fetch the initial token
    final String? token = await getToken();
    if (token != null) {
      _log('FCM Token: $token');
    } else {
      _log('Failed to get FCM token');
    }

    await registerMessageCallback();
    await registerMessageOpenedAppCallback();
  }

  @override
  Stream<({String title, String body})> get messageStream => _messageController.stream;

  @override
  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } on Object catch (e) {
      _log('Error getting FCM token: $e');
      return null;
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    final String? token = await getToken();
    if (token != null) {
      try {
        await _firebaseMessaging.subscribeToTopic(topic);
        _log('Subscribed to topic: $topic');
      } on Object catch (e) {
        _log('Error subscribe to topic [$topic]: $e');
        return;
      }
    } else {
      _log('Cannot subscribe to topic $topic: no FCM token');
    }
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    final String? token = await getToken();
    if (token != null) {
      try {
        await _firebaseMessaging.subscribeToTopic(topic);
        _log('Subscribed to topic: $topic');
      } on Object catch (e) {
        _log('Error subscribe to topic [$topic]: $e');
        return;
      }
    } else {
      _log('Cannot unsubscribe from topic $topic: no FCM token');
    }
  }

  @override
  Future<void> registerMessageCallback() async {
    FirebaseMessaging.onMessage.listen((message) async {
      final RemoteNotification? notification = message.notification;
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
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      final RemoteNotification? notification = message.notification;
      if (notification != null) {
        _log(
          'Notification title: ${notification.title}'
          'Notification body: ${notification.body}',
        );
        _messageController.add((title: notification.title ?? '', body: notification.body ?? ''));
      }
    });
  }

  Future<void> _initializeFirebase(String environment) => Firebase.initializeApp(
    name: switch (environment) {
      'DEV' => 'BAG24-DEV',
      'PROD' => 'BAG24-PROD',
      'STAGING' => 'BAG24-STAGE',
      _ => 'BAG24-DEV',
    },
    options: switch (environment) {
      'DEV' => dev.DefaultFirebaseOptions.currentPlatform,
      'PROD' => prod.DefaultFirebaseOptions.currentPlatform,
      'STAGING' => stage.DefaultFirebaseOptions.currentPlatform,
      _ => dev.DefaultFirebaseOptions.currentPlatform,
    },
  );

  void _log(String message) {
    if (kDebugMode) {
      developer.log(message, name: '[FirebaseCloudMessage]');
    }
  }
}
