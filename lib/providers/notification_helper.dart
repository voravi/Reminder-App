import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_app/modals/reminder.dart';
import 'package:timezone/timezone.dart' as tz;


class LocalNotificationHelper {
  LocalNotificationHelper._();

  static final LocalNotificationHelper localNotificationHelper = LocalNotificationHelper._();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initNotification(BuildContext context) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOs = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOs);


    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        log(notificationResponse.notificationResponseType.name, name: "Notification response time");
        log("${notificationResponse.payload}", name: "Notification Payload");

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("${notificationResponse.payload}"),
              content: Text("Thanks for visit here.."),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancle"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  showLocalScheduleNotification({required Reminder reminder}) async {

    final detroit = tz.getLocation('Asia/Kolkata');

    tz.TZDateTime _convertTime(int hour, int minutes) {
      tz.TZDateTime now = tz.TZDateTime.now(detroit);

      tz.TZDateTime scheduleDate = tz.TZDateTime(
        detroit,
        now.year,
        now.month,
        now.day,
        hour,
        minutes,
      );
      if (scheduleDate.isBefore(now)) {
        scheduleDate = scheduleDate.add(const Duration(days: 1));
      }
      return scheduleDate;
    }

    List<String> reminderTime = reminder.endTime.split(" ");
    int hour = int.parse(reminderTime[0]);
    int minute = int.parse(reminderTime[2]);

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      icon: 'mipmap/ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      reminder.task,
      reminder.taskDesc,
      _convertTime(hour, minute),
      platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

}