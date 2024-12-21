import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';


import '../../main.dart';
import '../app_pref.dart';
import '../event_bus_utils.dart';
import '../utility.dart';

// Background handler for Firebase Cloud Messaging (FCM)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  MyAppState.payload = message.data;
  final Map<String, dynamic> data = message.data;
  showLog('On Local Notification Click: $data');
  EventBusUtils.getInstance().fire(data);
  showLog('Handling a background message ${message.messageId}');
}

class NotificationHandler {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late FirebaseMessaging _firebaseMessaging;

  // Initializes notification settings and requests necessary permissions
  Future<void> initNotification() async {
    // Request notification permission if it is not granted
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Set up the background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      // Configure Android notification channel
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // Channel id
        'High Importance Notifications', // Channel title
        description: 'This channel is used for important notifications.',
        // Channel description
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      // Initialize the local notifications plugin
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // Create the notification channel
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Configure how notifications are displayed when the app is in the foreground
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // Set up Firebase Messaging and handle notifications
  Future<void> catchNotification() async {
    _firebaseMessaging = FirebaseMessaging.instance;

    // Get and store FCM token
    final String? fcmToken = await FirebaseMessaging.instance.getToken();
    showLog('FCM TOKEN: $fcmToken');
    await AppPref().putFcmToken(fcmToken ?? '');

    // Listen for token refreshes
    _firebaseMessaging.onTokenRefresh.listen((String updatedToken) async {
      showLog('FCM token refreshed: $updatedToken');
      if (await AppPref().getFcmToken() != updatedToken) {
        await AppPref().putFcmToken(updatedToken);
      }
    });

    // Initialize local notifications
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOs =
        DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentBanner: true,
      defaultPresentSound: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestProvisionalPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOs,
    );

    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onSelectNotification2,
      onDidReceiveBackgroundNotificationResponse: _onSelectNotification2,
    );

    // Request iOS notification permissions
    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }

    // Handle initial message when the app starts from a notification click
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        showLog('Initial Message found: ${message.data}');
        MyAppState.payload = message.data;
        final Map<String, dynamic> data = message.data;
        showLog('On Local Notification Click: $data');
        EventBusUtils.getInstance().fire(data);
      } else {
        showLog('Initial Message not found');
      }
    });

    // Handle messages when the app is running in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLog('Message Received: ${message.data}');
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.max,
              priority: Priority.max,
              showWhen: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });

    // Handle notification taps when the app is in running mode
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showLog('OnMessage Tap Initially: ${message.data}');
      _onSelectNotification(jsonEncode(message.data));
    });
  }

  // Handle notification tap when the app is in the background
  Future<void> _onSelectNotification(String? payload) async {
    try {
      final Map<String, dynamic> data =
          jsonDecode(payload!) as Map<String, dynamic>;
      showLog('On Local Notification Click: $data');
      EventBusUtils.getInstance().fire(data);
    } catch (e) {
      showLog('Error in data OnTapNotification: $e');
    }
  }

  // Handle notification tap when the app is in the background or closed
  Future<void> _onSelectNotification2(
      NotificationResponse? notificationResponse) async {
    try {
      final Map<String, dynamic> data =
          jsonDecode(notificationResponse!.payload!) as Map<String, dynamic>;
      showLog('On Local Notification Click: $data');
      EventBusUtils.getInstance().fire(data);
    } catch (e) {
      showLog('Error in data OnTapNotification: $e');
    }
  }
}
