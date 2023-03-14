import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:medical_chat_group/helper/helperFunctions.dart';
import 'package:medical_chat_group/model/firebase_messages.dart';
import 'package:http/http.dart' as http;
import 'package:medical_chat_group/model/jobModel.dart';
import 'package:medical_chat_group/model/notificationModel.dart';
import 'package:medical_chat_group/services/database.dart';
import 'package:medical_chat_group/views/NotificationDetailsPage.dart';
import 'package:medical_chat_group/views/jobDetails.dart';

// this function used in case of notification in background
Future<void> messageHandler(RemoteMessage message) async {
  NotificationMessages notificationMessages =
      NotificationMessages.fromJson(message.data);
  print("Notification from background " + notificationMessages.data.toString());
}

//this function used when phone be in foreground
void firebaseMessagingListener(BuildContext context) {
  FirebaseMessaging.onMessage.listen((message) {
    NotificationMessages notificationMessages =
        NotificationMessages.fromJson(message.data);

    JobModel jobModel = new JobModel(
        "",
        notificationMessages.data!.title.toString(),
        notificationMessages.data!.message.toString(),
        "");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (c) => new JobDetails(jobModel)));
    print(
        "Notification from foreground " + notificationMessages.data.toString());
  });
}

Future<void> sendNotification(String title, String body) async {
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  const String postURL = "https://fcm.googleapis.com/fcm/send";
  try {
    HelperFunctions.getUID().then((value) {
      NotificationModel notificationModel =
          NotificationModel("", value, title, body, false);
      dataBaseMethods.saveNotification(notificationModel);
    });
    dataBaseMethods.getAllUsersTokens().then((val) async {
//   Dio dio = new Dio();

//   var token = await getDeviceToken();
//   print("Device Token is :::" + token!);
// // this is static data => next i will get all tokens from firebase of all users and loop on theme to send notification
//   final data = {
//     "data": {
//       "title": "this from notification title",
//       "message": "this from message of notification"
//     },
//     "to": token
//   };

      print("token size ::::::::::::::::::::::::::::::::::::::::" +
          val.length.toString());
      for (int i = 0; i < val.length; i++) {
        await http.post(Uri.parse(postURL),
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "key=AAAAksF9pU0:APA91bElpYuaVCQsnVRp5N-rexgoDrykUziay2MEMIMB1kXYoqUXy1Qv8Tkr6rTdes4xTfCSedYn6_Ouz2_j1A8HbxBKOYFV1jI0tzPa2X6xv9WTEFO26ivuIRvieeC414D-87zcheEw"
            },
            body: jsonEncode(<String, dynamic>{
              "priority": "high",
              "data": <String, dynamic>{
                "click_action": "Flutter_NOTIFICATION_CLICK",
                "status": "done",
                "body": body,
                "title": title
              },
              "notification": <String, dynamic>{
                "title": title,
                "body": body,
                "android_channel_id": "medicalChatGroup"
              },
              "to": val[i]
            }));
        print("notification sent");
      }
    });
  } catch (error) {
    if (kDebugMode) {
      print("Error in Push Notification:::::::::::::");
    }
  }
  //   print("response ::::" + response.data);
  //   await dio.post(postURL, data: data, queryParameters: {
  //     dio.options.headers["Authorization"]:
  //         "key=AAAAAWdTnLw:APA91bE3F0TggdmYW4elUtxd_XuW7W6PhVBtCWLb7HlvhgsboM8WRMbJvq8FYFJd-pJ1pz9QnxSMlfG30ZlvJKz6OAUE93tPkuwPe9-Ll2siEmsLTLnC4mUYIWxnpyZvZVm_4opwVRJM",
  //     // HttpHeaders.contentTypeHeader: 'application/json'onBackGroundNotification
  //     dio.options.headers["Content-Type"]: 'application/json',
  //   });

  //   if (response.statusCode == 200) {
  //     print("Notification sent successfully");
  //   } else {
  //     print("Notification sending failed");
  //   }
  // } catch (error) {
  //   print("error in notification :::::::::::::::::::::::::::::::::" +
  //       error.toString());
  // }
}

Future<String?> getDeviceToken() {
  return FirebaseMessaging.instance.getToken();
}

Future<void> onBackGroundNotification(RemoteMessage message) async {
  print("on background message ${message.messageId}");
}

void getToken() async {
  bool firstRun = await IsFirstRun.isFirstRun();
  if (firstRun) {
    await FirebaseMessaging.instance.getToken().then((token) {
      print("Device Token is::::::::::::::::::::::::::::::: $token");
      HelperFunctions.saveToken(token!).then((value) {
        print("result of saving token :::::::::::::::::::::: " +
            value.toString());
      });
      ;
    });
  }
  await FirebaseMessaging.instance.getToken().then((token) {
    print("Device Token is::::::::::::::::::::::::::::::: $token");
    HelperFunctions.saveToken(token!).then((value) {
      print(
          "result of saving token :::::::::::::::::::::: " + value.toString());
    });
  });
}

void requestPermisson() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("User Granted Permission");
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print("User Granted provisional Permission");
  } else {
    print("User Denied or has not accepted");
  }
}

initInfo(BuildContext context) {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidInitialize =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  // var isoInitialize = const IOSInitializationSettings();
  var initializationSettings =
      InitializationSettings(android: androidInitialize);

  // flutterLocalNotificationsPlugin
  //     .getNotificationAppLaunchDetails()
  //     .then((value) {
  //   print("getNotificationAppLaunchDetails /////////////////////////////////${value!.notificationResponse}");
  // //   JobModel jobModel = new JobModel(
  // //      message.notification!.title.toString(),
  // //       message.notification!.body.toString());
  // //   Navigator.of(context)
  // //       .push(MaterialPageRoute(builder: (c) => new JobDetails(jobModel)));
  // });
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      try {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (c) => new NotificationDetailsPage()));
        print(
            "after receive notification ------------------------------------");

        if (details != null && details.toString().isNotEmpty) {}
      } catch (error) {}
    },
  );

  FirebaseMessaging.onMessage.listen((message) async {
    print(
        "on message: ${message.notification?.title}/${message.notification?.body}");
    if (message.notification!.title
        .toString()
        .contains("New message from chat")) {
      // show dialog contain message details
    } else {
      JobModel jobModel = new JobModel(
          "", message.notification!.title!, message.notification!.body!, "");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (c) => new JobDetails(jobModel)));
    }

    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "medicalChatGroup",
      "medicalChatGroup",
      importance: Importance.high,
      playSound: true,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
    );
    // sound: RawResourceAndroidNotificationSound("notification"));

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
        message.notification?.body, notificationDetails,
        payload: message.data["title"]);
  });
}

muteNofication() {
  FirebaseMessaging.instance.unsubscribeFromTopic('topic');
}

unmuteNofication() {
  FirebaseMessaging.instance.subscribeToTopic('topic');
}
