import 'package:flutter/material.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';
import 'package:fletes_31_app/src/ui/login_page.dart';
import 'package:fletes_31_app/src/ui/registration_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Navigation.navigationKey,
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        RegistrationPage.routeName: (context) => RegistrationPage(),
      },
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.orangeAccent,
        cursorColor: Colors.orangeAccent,
        textTheme: TextTheme(
          headline3: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            color: Colors.black,
          ),
          button: TextStyle(
            fontFamily: 'OpenSans',
          ),
          subtitle1: TextStyle(fontFamily: 'NotoSans'),
          bodyText2: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      home: LoginPage(),
    );
  }
}
