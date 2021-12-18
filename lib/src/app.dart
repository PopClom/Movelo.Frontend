import 'package:fletes_31_app/src/blocs/auth_bloc.dart';
import 'package:fletes_31_app/src/ui/about_us_page.dart';
import 'package:fletes_31_app/src/ui/contact_us_page.dart';
import 'package:fletes_31_app/src/ui/landing_page.dart';
import 'package:fletes_31_app/src/ui/travel_detail_page.dart';
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

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      navigatorKey: Navigation.navigationKey,
      routes: {
        RegistrationPage.routeName: (context) => _withScaffold(RegistrationPage()),
        AboutUsPage.routeName: (context) => _withScaffold(AboutUsPage()),
        NewTravelPage.routeName: (context) => _withScaffold(NewTravelPage()),
      },
      onGenerateRoute: (routeSettings) {
        RegExp travelRegExp = RegExp(r'^\/travels\/([0-9]+)\/?$');
        if (routeSettings.name != null && travelRegExp.hasMatch(routeSettings.name)) {
          final int travelId = int.parse(travelRegExp.firstMatch(routeSettings.name).group(1));
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => _withScaffold(TravelDetailPage(travelId)),
          );
        }
        return null;
      },
      theme: theme,
      title: 'Movelo',
      home: _withScaffold(LandingPage()),
    );
  }

  _withScaffold(Widget page) {
    return Column(
      verticalDirection: VerticalDirection.up,
      children: [
        Expanded(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: page,
          )
        ),
        StreamBuilder<bool>(
            stream: authBloc.isSessionValid,
            builder: (context, snap) {
              if (snap.hasData && snap.data) {
                return TopNavBar(
                    key: UniqueKey(),
                    navBarItems: navBarItemsLogged
                );
              } else {
                return TopNavBar(
                    key: UniqueKey(),
                    navBarItems: navBarItemsNotLogged
                );
              }
            }
        ),
      ],
    );
  }
}

List<NavBarItem> navBarItemsLogged = [
  NavBarItem(
    text: 'COTIZÁ',
    onTap: () {
      Navigator.pushNamed(
        Navigation.navigationKey.currentContext,
        NewTravelPage.routeName,
      );
    },
  ),
  NavBarItem(
    text: 'QUIENES SOMOS',
    onTap: () {
      Navigator.pushNamed(
        Navigation.navigationKey.currentContext,
        AboutUsPage.routeName,
      );
    },
  ),
  NavBarItem(
    text: 'MIS ENVÍOS',
    onTap: () {
      Navigator.pushNamed(
        Navigation.navigationKey.currentContext,
        TravelsPage.routeName,
      );
    },
  ),
  NavBarItem(
    text: 'CERRAR SESIÓN',
    onTap: () {
      authBloc.closeSession();
      Navigator.pushNamedAndRemoveUntil(
          Navigation.navigationKey.currentContext,'/',(_) => false
      );
    },
  ),
];

List<NavBarItem> navBarItemsNotLogged = [
  NavBarItem(
    text: 'COTIZÁ',
    onTap: () {
      Navigator.pushNamed(
        Navigation.navigationKey.currentContext,
        NewTravelPage.routeName,
      );
    },
  ),
  NavBarItem(
    text: 'QUIENES SOMOS',
    onTap: () {
      Navigator.pushNamed(
        Navigation.navigationKey.currentContext,
        AboutUsPage.routeName,
      );
    },
  ),
  NavBarItem(
    text: '@movelo.ar',
    onTap: () {
      const url = 'https://www.instagram.com/movelo.ar/';
      canLaunch(url).then((result) => {
        if (result) {
          launch(url)
        }
      });
    },
  ),
];