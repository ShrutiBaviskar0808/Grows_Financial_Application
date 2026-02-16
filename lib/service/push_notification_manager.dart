import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:growsfinancial/screens/document_requests_screen.dart';
import 'package:growsfinancial/utils/config.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;
  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final Config config = Config();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  bool _fcmInit = false;
  bool _localInit = false;

  /// Call once (after Firebase.initializeApp)
  Future<void> init() async {
    if (_fcmInit) return;

    // iOS permission (safe on Android too, but optional)
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) log("FCM permission: ${settings.authorizationStatus}");

    // Token
    final token = await _fcm.getToken();
    if (token != null) {
      config.setStringSharedPreferences("deviceToken", token);
      if (kDebugMode) log("FCM token: $token");
    }

    // iOS foreground display behavior
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _fcmInit = true;
  }

  /// Call once
  Future<void> localNotificationInit() async {
    if (_localInit) return;

    const androidInit = AndroidInitializationSettings('ic_app_logo');

    const iosInit = DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          onSelectNotification(payload);
        }
      },
    );

    _localInit = true;
  }

  /// Call once (e.g. in AppStateController.onReady())
  Future<void> configNotificationRouting() async {
    await init();
    await localNotificationInit();

    // Terminated -> opened by notification
    final initialMsg = await _fcm.getInitialMessage();
    if (initialMsg != null) {
      _handleRoutingFromMessage(initialMsg);
    }

    // Foreground
    FirebaseMessaging.onMessage.listen((message) {
      notificationHandle(message);
    });

    // Background -> opened by tap
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleRoutingFromMessage(message);
    });
  }

  void notificationHandle(RemoteMessage message) {
    final title = message.data['title'] ?? message.notification?.title ?? '';
    final body = message.data['body'] ?? message.notification?.body ?? '';
    final type = (message.data['type'] ?? '').toString();

    if (kDebugMode) log("FCM onMessage data: ${message.data}");

    // Only show local notification if you want it in foreground
    if (title.isNotEmpty || body.isNotEmpty) {
      showNotification(title, body, type);
    }
  }

  void _handleRoutingFromMessage(RemoteMessage message) {
    final type = (message.data['type'] ?? '').toString();
    if (type.isNotEmpty) {
      onSelectNotification(type);
    }
  }

  Future<void> showNotification(
    String title,
    String detail,
    String payload,
  ) async {
    final androidDetails = const AndroidNotificationDetails(
      'fcm_default_channel',
      'Global',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      // ongoing: true,  // ❌ remove unless you really need sticky notifications
      icon: 'ic_app_logo',
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000; // unique-ish
    await _local.show(id, title, detail, details, payload: payload);
  }

  Future<void> onSelectNotification(String payload) async {
    if (kDebugMode) log("Notification payload: $payload");

    // Support both formats:
    // "documentRequest"
    // "documentRequest:123"
    final parts = payload.split(':');
    final type = parts.first.trim();
    final data = (parts.length > 1) ? parts[1].trim() : null;

    if (type == "documentRequest") {
      Get.toNamed(DocumentRequestsScreen.id, arguments: data);
    }
  }

  void fcmSubscribe(String topicName) => _fcm.subscribeToTopic(topicName);

  void fcmUnSubscribe(String topicName) => _fcm.unsubscribeFromTopic(topicName);
}
