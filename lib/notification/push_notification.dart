import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/google_secret/google_secret.dart';




class PushNotificationSystem {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // final AudioPlayer audioPlayer=AudioPlayer();
  FlutterLocalNotificationsPlugin flutterLocalNotifications = FlutterLocalNotificationsPlugin();

    void requestNotificationPermission()async{
      NotificationSettings settings = await messaging.requestPermission(
        provisional: true,
        sound: true,
        alert: true,
        badge: true,
        announcement: true,
        carPlay: true,);

      if(settings.authorizationStatus == AuthorizationStatus.authorized){

      }else{
        Fluttertoast.showToast(msg: 'User denied permission');
      }
    }



    Future<void> initialize()async{
      AndroidInitializationSettings initializationSettingsAndroid  = AndroidInitializationSettings('@mipmap/ic_launcher');
      InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

      await flutterLocalNotifications.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse:handleNotificationResponse
      );

      FirebaseMessaging.onMessage.listen((event) {

      },);

      FirebaseMessaging.onMessageOpenedApp.listen((event) {

      },);

      FirebaseMessaging.instance.getInitialMessage().then((value) {

      },);
    }


    Future<void> handlerMessage()async{

    }



  void sendOrderNotification(
      {required String message, required String token}) async {
    final serverKey = await GoogleSecret.getServerKey();
    print('ServerKey:$serverKey');
    try {
      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/fir-apptest-c3e4e/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey',
        },
        body: jsonEncode(<String, dynamic>{
          "message": {
            "token": token,
            "data": {

            },
            "notification": {"title": 'Prince', "body": message}
          }

        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'send notification');
      } else {
        print(
            'Failed to send notification. Status Code: ${response.statusCode}');
        Fluttertoast.showToast(msg: "Failed to send notification ${response.statusCode}",);
      }
    } catch (e) {
      print('Error sending notification: $e');
      Fluttertoast.showToast(
        msg: "Error sending notification",
      );
    }
  }

  void handleNotificationResponse(NotificationResponse response) async {
    if (response.payload != null && response.input != null) {
      Map<String, dynamic> data = jsonDecode(response.payload!);
      String replyText = response.input!;
    }
  }


}
