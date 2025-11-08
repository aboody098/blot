import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:fire_safety_console/core/logger.dart';
import 'package:fire_safety_console/data/models/incident.dart';

typedef NotificationCallback = Function(String payload);

class NotificationService extends GetxService {
  static final NotificationService _instance =
      NotificationService._internal();

  late FirebaseMessaging _firebaseMessaging;
  late FlutterLocalNotificationsPlugin _localNotifications;
  final List<NotificationCallback> _callbacks = [];

  NotificationService._internal() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _localNotifications = FlutterLocalNotificationsPlugin();
  }

  factory NotificationService() {
    return _instance;
  }

  @override
  Future<NotificationService> onInit() async {
    super.onInit();
    await _initializeLocalNotifications();
    await _initializeFirebaseMessaging();
    return this;
  }

  Future<void> _initializeLocalNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationTap(response.payload);
      },
    );

    Logger.info('Local notifications initialized',
        tag: 'NotificationService');
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Request permission
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carplay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    Logger.info('Firebase Messaging permission: ${settings.authorizationStatus}',
        tag: 'NotificationService');

    // Get FCM token
    final token = await _firebaseMessaging.getToken();
    Logger.info('FCM Token: $token', tag: 'NotificationService');

    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Logger.info('Foreground message received: ${message.notification?.title}',
          tag: 'NotificationService');
      _handleMessage(message);
    });

    // Handle messages when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Logger.info('App opened from message: ${message.notification?.title}',
          tag: 'NotificationService');
      _handleNotificationTap(message.data['id']);
    });
  }

  void _handleMessage(RemoteMessage message) {
    final notification = message.notification;

    if (notification != null) {
      _showLocalNotification(
        title: notification.title ?? 'Alert',
        body: notification.body ?? '',
        payload: message.data['id'] ?? '',
        priority: _getPriority(message.data['severity']),
      );
    }
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      for (final callback in _callbacks) {
        callback(payload);
      }
    }
  }

  NotificationImportance _getPriority(String? severity) {
    switch (severity) {
      case 'CRITICAL':
        return NotificationImportance.max;
      case 'MAJOR':
        return NotificationImportance.high;
      case 'MINOR':
        return NotificationImportance.default_;
      default:
        return NotificationImportance.default_;
    }
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    required String payload,
    NotificationImportance priority = NotificationImportance.high,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'fire_safety_channel',
      'Fire Safety Alerts',
      channelDescription: 'Critical safety alerts and notifications',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: payload,
    );

    Logger.info('Local notification shown: $title', tag: 'NotificationService');
  }

  // Public methods
  Future<void> showIncidentNotification(Incident incident) async {
    await _showLocalNotification(
      title: incident.title,
      body: incident.description,
      payload: incident.id,
      priority: _getPriority(incident.severity),
    );
  }

  Future<void> showCustomNotification({
    required String title,
    required String body,
    required String id,
  }) async {
    await _showLocalNotification(
      title: title,
      body: body,
      payload: id,
    );
  }

  void onNotificationTap(NotificationCallback callback) {
    _callbacks.add(callback);
  }

  void removeCallback(NotificationCallback callback) {
    _callbacks.remove(callback);
  }

  Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      Logger.error('Failed to get FCM token', tag: 'NotificationService',
          exception: e);
      return null;
    }
  }

  Stream<String> get onTokenRefresh {
    return _firebaseMessaging.onTokenRefresh;
  }

  @override
  void onClose() {
    _callbacks.clear();
    super.onClose();
  }
}
