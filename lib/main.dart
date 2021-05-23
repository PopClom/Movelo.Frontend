import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:fletes_31_app/src/app.dart';


void main() {
  // check if is running on Web
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.instance.webInitialize(
      appId: '871698410048244',//<-- YOUR APP_ID
      cookie: true,
      xfbml: true,
      version: 'v9.0',
    );
  }
  setPathUrlStrategy();
  runApp(MyApp());
}
