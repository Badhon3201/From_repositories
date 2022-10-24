import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../feature/view_models/view_models.dart';

class DownloadingDialog extends StatefulWidget {
  DownloadingDialog({
    Key? key,
  }) : super(key: key) {
    controller = Get.put(ViewModels());
  }
  late final ViewModels controller;

  @override
  _DownloadingDialogState createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  Dio dio = Dio();
  double progress = 0.0;

  void startDownloading() async {
    const String url = 'http://www.pdf995.com/samples/pdf.pdf';
    const String? fileName = "TV.pdf";
    widget.controller.path.value =
        await widget.controller.getFilePath(fileName);
    print(widget.controller.path.value);
    await dio.download(
      url,
      widget.controller.path.value,
      onReceiveProgress: (recivedBytes, totalBytes) {
        setState(() {
          progress = recivedBytes / totalBytes;
        });

        print(progress);
      },
      deleteOnError: true,
    ).then((_) {
      NotificationDetails notificationDetails = const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel ID',
            'channel name',
            playSound: true,
            priority: Priority.high,
            importance: Importance.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ));
      if (Platform.isAndroid) {
        print("Flutter Local Notification");
        // LocalNotificationService().showNotification("title", "body");
        FlutterLocalNotificationsPlugin().show(
          0,
          widget.controller.path.value,
          null,
          notificationDetails,
        );
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          log('A new onMessageOpenedApp event was published!');
          RemoteNotification? notification = message.notification;
          if (notification != null) {
            log("After open: ${message.data}");
            log(message.data['action']);
          }
        });
      }
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    startDownloading();
  }

  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();

    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Downloading: $downloadingprogress%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
