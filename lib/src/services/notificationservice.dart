import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    // Android initialization
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios initialization
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // request permission
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showNotification(int id, String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          // Android details
          android: AndroidNotificationDetails('main_channel', 'Main Channel',
              channelDescription: "rinwallet",
              importance: Importance.max,
              priority: Priority.max),
          // iOS details
          iOS: DarwinNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: 'item x');
  }

  Future<void> scheduleShowNotification(
      int id, String title, String body, Duration duration) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local)
          .add(duration), //schedule the notification to show after 2 seconds.
      const NotificationDetails(
        // Android details
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            channelDescription: "rinwallet",
            importance: Importance.max,
            priority: Priority.max),
        // iOS details
        iOS: DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),

      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }

  void getAllScheduleNotifications() async {
    var res = await flutterLocalNotificationsPlugin.getActiveNotifications();
    res.forEach((element) {
      print(element.title);
    });
  }

  // void requestPermission() {
  //   flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.requestNotificationsPermission();
  // }
}
