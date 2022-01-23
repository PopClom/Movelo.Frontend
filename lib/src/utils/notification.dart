import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  //print("onBackgroundMessage");

  await Firebase.initializeApp();
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  setNotifications() async {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    // handle when app in active state
    foregroundNotification();

    // handle when app running in background state
    backgroundNotification();

    // handle when app completely closed by the user
    terminateNotification();

    // With this token you can test it easily on your phone
    return await _firebaseMessaging.getToken();
  }

  foregroundNotification() {
    FirebaseMessaging.onMessage.listen(
          (message) async {
            //print("foregroundNotification");
      },
    );
  }

  backgroundNotification() {
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) async {
        //print("backgroundNotification");
      },
    );
  }

  terminateNotification() async {
    RemoteMessage initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      //print("terminateNotification");
    }
  }
}