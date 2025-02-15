import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<bool?> requestOTP(String phoneNumber)async{

    Completer<bool?> completer = Completer<bool?>();
    try{
      auth.verifyPhoneNumber(
          phoneNumber: '+91$phoneNumber',
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          completer.complete(true);
          },
          verificationFailed:  (FirebaseAuthException error) {
            Fluttertoast.showToast(msg: '$error');
            completer.complete(false);
          },

          codeSent: (String verificationId, int? forceResendingToken) {
            completer.complete(true);
          },

          codeAutoRetrievalTimeout:  (String verificationId) {
            Fluttertoast.showToast(msg: "OTP Timeout");
            completer.complete(false);
          }

      );
      return completer.future;
    }catch(error){

      Fluttertoast.showToast(msg: 'Request OTP Error $error');
      return false;
    }
  }


  Future<bool?> signInWithGoogle() async {
    Completer<bool?> completer = Completer<bool?>();

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(credential);
        Fluttertoast.showToast(msg: 'Google auth success');

        completer.complete(true);
      } else {
        Fluttertoast.showToast(msg: 'Google Sign-In aborted');
        completer.complete(false);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      completer.complete(false);
    }

    return completer.future;
  }


}