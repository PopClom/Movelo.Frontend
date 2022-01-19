import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fletes_31_app/src/blocs/auth_bloc.dart';
import 'package:fletes_31_app/src/utils/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:fletes_31_app/src/app.dart';


void main() async {
  // check if is running on Web
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.instance.webInitialize(
      appId: '402647127967687',//<-- YOUR APP_ID
      cookie: true,
      xfbml: true,
      version: 'v9.0',
    );
  }
  setPathUrlStrategy();
  authBloc.restoreSession();
  await initializeFirebase();
  runApp(MyApp());
}

Future initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  authBloc.isSessionValid.listen((isValid) {
    if (isValid) {
      final firebaseMessaging = FCM();
      firebaseMessaging.setNotifications();
    }
  });
}