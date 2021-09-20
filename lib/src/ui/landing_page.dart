import 'dart:math';
import 'package:fletes_31_app/src/ui/fragments/new_travel_fragment.dart';
import 'package:fletes_31_app/src/ui/components/info_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
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
    final deviceSize = MediaQuery.of(context).size;
    final width = min(deviceSize.width * 0.95, 1000.0);

    return Container(
        alignment: Alignment.center,
        child: ListView(
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Image.asset(
                    'assets/images/landing-background.png',
                    fit: BoxFit.cover,
                    height: 650,
                    width: deviceSize.width,
                  ),
                  Column(
                    children: [
                      SizedBox(height: 80),
                      Container(
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Card(
                            color: Color.fromRGBO(96, 46, 209, 1),
                            child: NewTravelFragment()
                        ),
                      )
                    ],
                  )
                ],
              ),
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Image.asset(
                    'assets/images/pasos-desktop.png',
                    fit: BoxFit.fitHeight,
                    height: 600,
                  ),
                  Column(
                    children: [
                      SizedBox(height: 40),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          '¿Cómo hacer tu viaje?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Seguridad y pagos',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                height: 340,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InfoCard(
                        title: 'Tenemos VTV',
                        text: 'Nuestra flota cuenta con verificación técnica vehicular obligatoria',
                        picture: Image.asset(
                          'assets/images/vtv-logo.png',
                          height: 100,
                        ),
                      ),
                      InfoCard(
                        title: 'Somos Seguros',
                        text: 'Nuestra flota cuenta con póliza de seguro y seguro de carga',
                        picture: Image.asset(
                          'assets/images/seguros-logo.png',
                          height: 100,
                        ),
                      ),
                      InfoCard(
                        title: '¿Cómo pagar?',
                        text: 'Efectivo, transferencia bancaria, Mercado Pago y pago electrónico',
                        picture: Image.asset(
                          'assets/images/mp-logo.png',
                          height: 100,
                        ),
                      ),
                    ],
                  )
                ),
              ),
              /*CarouselSlider(
                options: CarouselOptions(height: 320.0, viewportFraction: 0.30),
                items: [1,2,3].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return InfoCard(
                        title: 'Tenemos VTV',
                        text: 'Nuestra flota cuenta con verificación técnica vehicular obligatoria',
                        picture: Image.asset(
                          'assets/images/vtv-logo.png',
                          height: 100,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),*/
              SizedBox(height: 80),
            ]
        ),
    );
  }
}
