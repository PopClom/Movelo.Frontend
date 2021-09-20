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
                      SizedBox(height: 30),
                      Image.asset(
                        'assets/images/header.png',
                        fit: BoxFit.fitWidth,
                        width: width * 0.6,
                      ),
                      SizedBox(height: 30),
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
                  deviceSize.width > 860 ?
                  Image.asset(
                    'assets/images/pasos-desktop.png',
                    fit: BoxFit.fitHeight,
                    height: 500,
                  ) : (deviceSize.width > 620 ? Image.asset(
                    'assets/images/pasos-tablet.png',
                    fit: BoxFit.fitHeight,
                    height: 900,
                  ) : Image.asset(
                    'assets/images/pasos-mobile.png',
                    fit: BoxFit.fitHeight,
                    height: 1000,
                  )),
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
                          height: 120,
                        ),
                      ),
                      InfoCard(
                        title: '¿Cómo pagar?',
                        text: 'Efectivo, transferencia bancaria, Mercado Pago y pago electrónico',
                        picture: Image.asset(
                          'assets/images/mp-logo.png',
                          height: 120,
                        ),
                      ),
                    ],
                  )
                ),
              ),
              SizedBox(height: 50),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Empresas que confían en nosotros',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                    height: 240.0,
                    viewportFraction: deviceSize.width > 860 ? 0.25 :
                    (deviceSize.width > 480 ? 0.4 : 0.5)
                ),
                items: [
                  Image.asset(
                    'assets/images/farmacity-logo.png',
                    width: 180,
                  ),
                  Image.asset(
                    'assets/images/lomanegra-logo.png',
                    width: 140,
                  ),
                  Image.asset(
                    'assets/images/redbull-logo.png',
                    width: 180,
                  ),
                  Image.asset(
                    'assets/images/welivery-logo.png',
                    width: 180,
                  ),
                ]
              ),
              SizedBox(height: 40),
              Image.asset(
                'assets/images/footer.png',
                fit: BoxFit.fitHeight,
                height: 184,
              ),
            ]
        ),
    );
  }
}
