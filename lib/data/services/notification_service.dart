import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ghanta_gadi/core/constant/asset_constant.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  // Channel for Android notifications
  static const AndroidNotificationChannel _androidChannel =
  AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  /// Initialize all notification handlers
  Future<void> init() async {
    // Initialize Local Notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint("Notification tapped: ${response.payload}");
      },
    );

    // Create Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Request permissions (iOS + Android 13+)
    await _requestPermission();

    // Set foreground presentation options (iOS)
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle Notification taps (background or terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("App opened from background via notification: ${message.data}");
      _handleNotificationClick(message);
    });

    // Handle when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint("App opened from terminated state via notification");
        _handleNotificationClick(message);
      }
    });
  }

  /// Request permissions for notifications
  Future<void> _requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Notification permission granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('Provisional notification permission granted');
    } else {
      debugPrint('Notification permission denied');
    }
  }

  /// Handle foreground FCM messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final android = notification?.android;

    if (notification != null && android != null && !Platform.isIOS) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title ?? 'No Title',
        notification.body ?? 'No Body',
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: android.smallIcon ?? '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  /// Optional: Handle navigation when user taps the notification
  void _handleNotificationClick(RemoteMessage message) {
    final data = message.data;
    debugPrint("Notification clicked with data: $data");
  }

  /// Send a local notification manually
  Future<void> sendLocalNotification(String title, String body) async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'manual_channel',
          'Manual Notifications',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
      ),
    );
  }

  /// Fetch FCM Token
  static Future<String?> getFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM Token: $token");
    return token;
  }

  /// Listen for token refresh
  void listenTokenRefresh(void Function(String) onTokenRefresh) {
    FirebaseMessaging.instance.onTokenRefresh.listen(onTokenRefresh);
  }

  Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
  }) async {

    final accessToken = await _getAccessToken();

    final url = Uri.parse('https://fcm.googleapis.com/v1/projects/ghanta-gadi-2ebb2/messages:send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final payload = {
      'to': token,
      'notification': {
        'title': title,
        'body': body,
      },
      'priority': 'high',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print('✅ Notification sent successfully');
    } else {
      print('❌ Failed to send notification: ${response.body}');
    }
  }


  /// Delete FCM token (for logout)
  static Future<void> deleteToken() async {
    await FirebaseMessaging.instance.deleteToken();
    debugPrint("FCM Token deleted");
  }

  Future<String> _getAccessToken() async {
    final serviceAccountJson = await rootBundle.loadString(AssetConstant.serviceAccount);

    final accountCredentials = auth.ServiceAccountCredentials.fromJson(serviceAccountJson);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await auth.clientViaServiceAccount(accountCredentials, scopes);
    final credentials = client.credentials;
    final token = credentials.accessToken.data;
    client.close();

    return token;
  }
}
