import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:fletes_31_app/src/ui/fragments/new_travel_fragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/';

  const LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
          color: Color.fromRGBO(96, 46, 209, 1),
          child: NewTravelFragment()
      ),
    );
  }
}
