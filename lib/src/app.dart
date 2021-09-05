import 'package:fletes_31_app/src/ui/new_travel_page.dart';
import 'package:flutter/material.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';
import 'package:fletes_31_app/src/ui/login_page.dart';
import 'package:fletes_31_app/src/ui/registration_page.dart';
import 'package:fletes_31_app/src/ui/travels_page.dart';

ThemeData theme = ThemeData(
  primarySwatch: Colors.orange,
  accentColor: Colors.orangeAccent,
  cursorColor: Colors.orangeAccent,
  textTheme: TextTheme(
    headline3: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 20.0,
      color: Colors.black,
    ),
    button: TextStyle(
      fontFamily: 'OpenSans',
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

double collapsableHeight = 0.0;
Color selected = Color(0xffffffff);
Color notSelected = Color(0xafffffff);

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
      initialRoute: "/login",
      home: PageBody(),
    );
  }
}

class PageBody extends StatefulWidget {
  @override
  _PageBodyState createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.white,
                ),
                AnimatedContainer(
                  margin: EdgeInsets.only(top: 79.0),
                  duration: Duration(milliseconds: 375),
                  curve: Curves.ease,
                  height: (width < 800.0) ? collapsableHeight : 0.0,
                  width: double.infinity,
                  color: Color(0xff121212),
                  child: SingleChildScrollView(
                    child: Column(
                      children: navBarItems,
                    ),
                  ),
                ),
                Container(
                  color: Color(0xff121212),
                  height: 80.0,
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Movelo',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Color(0xffffffff),
                        ),
                      ),
                      LayoutBuilder(builder: (context, constraints) {
                        if (width < 800.0) {
                          return NavBarButton(
                            onPressed: () {
                              if (collapsableHeight == 0.0) {
                                setState(() {
                                  collapsableHeight = 240.0;
                                });
                              } else if (collapsableHeight == 240.0) {
                                setState(() {
                                  collapsableHeight = 0.0;
                                });
                              }
                            },
                          );
                        } else {
                          return Row(
                            children: navBarItems,
                          );
                        }
                      })
                    ],
                  ),
                ),
              ],
            ),
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
    );
  }
}

List<Widget> navBarItems = [
  NavBarItem(
    text: 'Cotizar',
    path: NewTravelPage.routeName,
  ),
  NavBarItem(
    text: 'Mis solicitudes',
    path: TravelsPage.routeName,
  ),
  NavBarItem(
    text: 'Iniciar sesión',
    path: LoginPage.routeName,
  ),
];

class NavBarItem extends StatefulWidget {
  final String text;
  final String path;

  NavBarItem({
    this.text,
    this.path,
  });

  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  Color color = notSelected;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          color = selected;
        });
      },
      onExit: (value) {
        setState(() {
          color = notSelected;
        });
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white60,
          onTap: () {
            Navigator.pushReplacementNamed(
              Navigation.navigationKey.currentContext,
              widget.path,
            );
          },
          child: Container(
            height: 60.0,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 16.0,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavBarButton extends StatefulWidget {
  final Function onPressed;

  NavBarButton({
    this.onPressed,
  });

  @override
  _NavBarButtonState createState() => _NavBarButtonState();
}

class _NavBarButtonState extends State<NavBarButton> {
  Widget build(BuildContext context) {
    return Container(
      height: 55.0,
      width: 60.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xcfffffff),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          splashColor: Colors.white60,
          onTap: () {
            setState(() {
              widget.onPressed();
            });
          },
          child: Icon(
            Icons.menu,
            size: 30.0,
            color: Color(0xcfffffff),
          ),
        ),
      ),
    );
  }
}
