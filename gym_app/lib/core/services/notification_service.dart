import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int restTimerNotificationId = 3001;
  static const String restTimerChannelId = 'rest_timer_channel';
  static const String restTimerChannelName = 'Rest Timer';
  static const String restTimerChannelDescription =
      'Notifications for the gym rest timer';

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(initializationSettings);

    tz.initializeTimeZones();

    try {
      final currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  static Future<void> scheduleThreeMinuteAlert() async {
    await cancelThreeMinuteAlert();

    const androidDetails = AndroidNotificationDetails(
      restTimerChannelId,
      restTimerChannelName,
      channelDescription: restTimerChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      restTimerNotificationId,
      'Rest timer',
      '3 minutes reached.',
      tz.TZDateTime.now(tz.local).add(const Duration(minutes: 3)),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelThreeMinuteAlert() async {
    await _plugin.cancel(restTimerNotificationId);
  }
}
