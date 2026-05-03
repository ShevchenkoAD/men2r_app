import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:men2r_app/l10n/app_localizations.dart'; 
import '../course.dart'; // Путь к модели курса
import '../../main.dart'; 

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  AppLocalizations _getL10n() {
    final context = navigatorKey.currentContext;
    if (context == null) throw Exception("Navigator context is null");
    return AppLocalizations.of(context)!;
  }

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        navigatorKey.currentState?.pushReplacementNamed('/courses');
      },
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Общий приватный метод для планирования уведомления
  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime targetDate,
  }) async {
    // Напоминаем за 1 час до события
    final DateTime scheduledTime = targetDate.subtract(const Duration(hours: 1));

    // Если время напоминания уже в прошлом, не планируем
    if (scheduledTime.isBefore(DateTime.now())) return;

    final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);
    final l10n = _getL10n();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'course_reminders_channel',
      'Course Notifications', // Это имя можно вынести в l10n.notification_channel_name
      importance: Importance.max,
      priority: Priority.high,
    );

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzScheduledDate,
      notificationDetails: const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Планирование ДВУХ уведомлений для курса
  Future<void> scheduleCourseReminders(Course course) async {
    final l10n = _getL10n();
    
    final DateTime startTime = DateTime.parse(course.startDate);
    final DateTime endTime = DateTime.parse(course.endDate);

    final String startFmt = "${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}";
    final String endFmt = "${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}";

    // 1. Уведомление на начало (ID = serverId * 2)
    await _schedule(
      id: course.serverId * 2,
      title: l10n.notification_title_start,
      body: l10n.notification_body_start(course.title, startFmt),
      targetDate: startTime,
    );

    // 2. Уведомление на конец (ID = serverId * 2 + 1)
    await _schedule(
      id: (course.serverId * 2) + 1,
      title: l10n.notification_title_end,
      body: l10n.notification_body_end(course.title, endFmt),
      targetDate: endTime,
    );
  }

  /// Отмена уведомлений для конкретного курса
  Future<void> cancelCourseNotifications(int serverId) async {
    await _notifications.cancel(id: serverId * 2);
    await _notifications.cancel(id: (serverId * 2) + 1);
  }
}