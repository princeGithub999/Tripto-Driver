import 'dart:convert';
import 'dart:ui';
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


  Future<void> showNotification(RemoteMessage message) async {
    if (message.notification == null) {
      print("❌ Error: Notification data is null.");
      return;
    }

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'ride_request_channel_id',
      'Ride Requests',
      channelDescription: 'Ride request notifications with quick actions',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'New Ride Request',
      color: Color(0xFF2196F3),
      enableLights: true,
      enableVibration: true,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'accept_action_id',
          '✅ Accept',
          titleColor: Color(0xFF4CAF50),
        ),
        AndroidNotificationAction(
          'reject_action_id',
          '❌ Reject',
          titleColor: Color(0xFFF44336),
        ),
      ],
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    try {
      await flutterLocalNotifications.show(
        0,
        message.notification?.title ?? "🚗 Ride Request",
        message.notification?.body ?? "You have a new ride request!",
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      print("❌ Error in showNotification: $e");
    }
  }
    Future<void> handlerMessage()async{

    }



  void sendOrderNotification(String fcmToken) async {
    String? token = await FirebaseMessaging.instance.getToken();
    print('Token :- $fcmToken');
    final serverKey = await GoogleSecret.getServerKey();
    print('ServerKey:$serverKey');
    // print('Fcm Token :- $fcmToken');

    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/fir-apptest-c3e4e/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey',
        },
        body: jsonEncode(<String, dynamic>{
          "message": {
            "token": fcmToken,
            "notification": {
              "title": 'Prince',
              "body": 'confrom your ride'
            }
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
