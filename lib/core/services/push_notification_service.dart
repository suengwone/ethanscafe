import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

String? routeFromMessageData(Map<String, dynamic> data) {
  final route = data['route'];
  if (route is! String) {
    return null;
  }
  final trimmed = route.trim();
  if (trimmed.isEmpty || !trimmed.startsWith('/')) {
    return null;
  }
  return trimmed;
}

class PushNotificationService {
  PushNotificationService({
    required this.onNavigate,
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  final void Function(String route) onNavigate;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  static const androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    '중요 알림',
    description: '주문 상태, 이벤트 등 앱 푸시 알림',
    importance: Importance.high,
  );

  bool _initialized = false;
  final _subscriptions = <StreamSubscription<dynamic>>[];

  Stream<String> tokenStream() async* {
    final token = await _messaging.getToken();
    if (token != null) {
      yield token;
    }
    yield* _messaging.onTokenRefresh;
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    await _messaging.requestPermission();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onLocalNotificationTapped,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    _subscriptions.add(
      FirebaseMessaging.onMessage.listen(_showForegroundNotification),
    );
    _subscriptions.add(
      FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedMessage),
    );

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleOpenedMessage(initialMessage);
    }
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    _initialized = false;
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null || notification.android == null) {
      return;
    }
    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannel.id,
          androidChannel.name,
          channelDescription: androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: routeFromMessageData(message.data),
    );
  }

  void _handleOpenedMessage(RemoteMessage message) {
    final route = routeFromMessageData(message.data);
    if (route != null) {
      onNavigate(route);
    }
  }

  void _onLocalNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) {
      return;
    }
    final route = routeFromMessageData({'route': payload});
    if (route != null) {
      onNavigate(route);
    }
  }
}
