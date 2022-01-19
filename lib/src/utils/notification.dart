import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  print("MENSAJEE4");

  await Firebase.initializeApp();
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  setNotifications() async {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    // handle when app in active state
    forgroundNotification();

    // handle when app running in background state
    backgroundNotification();

    // handle when app completely closed by the user
    terminateNotification();

    // With this token you can test it easily on your phone
    final token = await _firebaseMessaging.getToken();
    print('Token: $token');
  }

  forgroundNotification() {
    FirebaseMessaging.onMessage.listen(
          (message) async {
            print("MENSAJEE2");
      },
    );
  }

  backgroundNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) async {
        print("MENSAJEE3");
      },
    );
  }

  terminateNotification() async {
    RemoteMessage initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("MENSAJEE1");
    }
  }
}