import 'package:flutter/material.dart';
import 'package:fletes_31_app/src/ui/new_travel_page.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';
import 'package:fletes_31_app/src/ui/login_page.dart';
import 'package:fletes_31_app/src/ui/registration_page.dart';
import 'package:fletes_31_app/src/ui/travels_page.dart';
import 'package:fletes_31_app/src/ui/components/top_nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

ThemeData theme = ThemeData(
  primarySwatch: Colors.deepPurple,
  accentColor: Colors.deepPurpleAccent,
  cursorColor: Colors.deepPurpleAccent,
  textTheme: TextTheme(
    headline3: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20.0,
      color: Colors.black,
    ),
    button: TextStyle(
      fontFamily: 'Poppins',
    ),
    subtitle1: TextStyle(
        fontFamily: 'Poppins',
        color: Colors.black
    ),
    subtitle2: TextStyle(
        fontFamily: 'Poppins',
        color: Colors.black54,
        fontSize: 12.5
    ),
    bodyText2: TextStyle(fontFamily: 'Poppins'),
  ),
);

List<Widget> navBarItems = [
  NavBarItem(
    text: 'QUIENES SOMOS',
    onTap: () {
      Navigator.pushReplacementNamed(
        Navigation.navigationKey.currentContext,
        NewTravelPage.routeName,
      );
    },
  ),
  NavBarItem(
    text: 'COTIZÁ',
    onTap: () {
      Navigator.pushReplacementNamed(
        Navigation.navigationKey.currentContext,
        NewTravelPage.routeName,
      );
    },
  ),
  NavBarItem(
    text: 'CONTACTANOS',
    onTap: () {
      Navigator.pushReplacementNamed(
        Navigation.navigationKey.currentContext,
        TravelsPage.routeName,
      );
    },
  ),
  NavBarItem(
    text: '@movelo',
    onTap: () {
      const url = 'https://www.instagram.com/movelo.ar/';
      canLaunch(url).then((result) => {
        if (result) {
          launch(url)
        }
      });
    },
  ),
  NavBarItem(
    text: 'INGRESÁ',
    onTap: () {
      Navigator.pushReplacementNamed(
        Navigation.navigationKey.currentContext,
        LoginPage.routeName,
      );
    },
  ),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        WidgetsBinding.instance.addPostFrameCallback((_) =>
            Navigator.pushReplacementNamed(
              Navigation.navigationKey.currentContext,
              settings.name,
            )
        );
        return null;
      },
      title: 'Movelo',
      initialRoute: '/login',
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              TopNavBar(navBarItems: navBarItems),
              Expanded(
                  child: MaterialApp(
                    navigatorKey: Navigation.navigationKey,
                    routes: {
                      LoginPage.routeName: (context) => LoginPage(),
                      RegistrationPage.routeName: (context) => RegistrationPage(),
                      NewTravelPage.routeName: (context) => NewTravelPage(),
                      TravelsPage.routeName: (context) => TravelsPage(),
                    },
                    title: 'Movelo',
                    theme: theme,
                    home: LoginPage(),
                  )
              ),
            ],
          )
      ),
    );
  }
}
