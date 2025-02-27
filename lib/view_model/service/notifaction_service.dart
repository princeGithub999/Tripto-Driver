import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationService {

  Future<String?> getDeviceToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        return token;
      } else {
        Fluttertoast.showToast(msg: 'FCM Token is null');
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      return null;
    }
  }
}