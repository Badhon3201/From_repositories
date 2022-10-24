import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static const channelId = "";
  static const channelName = "";
  static const String channelDescription = " Notification";
  static const compressionProgressNotificationId = 15;
  static const compressionFinishedNotificationId = 16;
  bool _isInitialized = false;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeIfNeeded() async {
    if (!_isInitialized) {
      await Future.delayed(const Duration(seconds: 1));
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('notification_icon');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      );
      _isInitialized = true;
      return;
    } else {
      return;
    }
  }

  Future _selectNotification(String payload) async {
    var decodedPayload = json.decode(payload);

    if (decodedPayload['type'] == "OPEN_FILE") {
      if (decodedPayload["data"] != null) {
        if (decodedPayload["data"]["filePath"] != null) {
          String path = "${decodedPayload["data"]["filePath"]}";
          // OpenFile.open(path);
        }
      }
    }
  }

  showNotification(String title, String body, {String? payload}) {
    var notificationDetails = const NotificationDetails(
        android: AndroidNotificationDetails(
      channelId,
      channelName,
      color: Colors.blue,
    ));
    _flutterLocalNotificationsPlugin.show(
        compressionFinishedNotificationId, title, body, notificationDetails,
        payload: payload);
  }

  Future<void> closeProgressNotification() {
    return _flutterLocalNotificationsPlugin
        .cancel(compressionProgressNotificationId);
  }

  Future<void> closeCompressFinishedNotification() {
    return _flutterLocalNotificationsPlugin
        .cancel(compressionFinishedNotificationId);
  }

  Future onDidReceiveLocalNotification(int id, String title, String body,
      String payload, BuildContext context) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }
}
