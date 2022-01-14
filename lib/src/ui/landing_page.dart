import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fletes_31_app/src/utils/notification.dart';
import 'package:fletes_31_app/src/ui/fragments/footer_fragment.dart';
import 'package:fletes_31_app/src/ui/fragments/new_travel_fragment.dart';
import 'package:fletes_31_app/src/ui/components/info_card.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/';

  const LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
        alignment: Alignment.center,
        child: ListView(
            children: [
              _newTravelSection(deviceSize.width),
              _stepsSection(deviceSize.width),
              SizedBox(height: 20),
              _ourServicesSection(),
              SizedBox(height: 50),
              _infoSection(),
              SizedBox(height: 50),
              _companiesSection(deviceSize.width),
              SizedBox(height: 40),
              Footer(),
            ]
        ),
    );
  }

  Widget _newTravelSection(double deviceWidth) {
    final width = min(deviceWidth, 1000.0);

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Image.asset(
          'assets/images/landing/landing-background.png',
          fit: BoxFit.cover,
          height: 650,
          width: deviceWidth,
        ),
        Column(
          children: [
            SizedBox(height: 30),
            Image.asset(
              'assets/images/landing/header.png',
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
    );
  }

  _stepsSection(double deviceWidth) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        deviceWidth > 860 ?
        Image.asset(
          'assets/images/landing/pasos-desktop.png',
          fit: BoxFit.fitHeight,
          height: 500,
        ) : (deviceWidth > 620 ? Image.asset(
          'assets/images/landing/pasos-tablet.png',
          fit: BoxFit.fitHeight,
          height: 915,
        ) : Image.asset(
          'assets/images/landing/pasos-mobile.png',
          fit: BoxFit.fitHeight,
          height: 840,
        )),
        Column(
          children: [
            SizedBox(height: 40),
            Text(
              '¡Cinco pasos y Movelo!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
      ],
    );
  }

  _ourServicesSection() {
    return Column(
      children: [
        Text(
          'Nuestros servicios',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w600,
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
                    title: 'Traslados',
                    text: 'Traslados las 24hs del día.',
                    picture: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Contratá nuestro servicio con un mínimo de 4 hs de anticipación mediante nuestra página web o Central de Whatsapp.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  InfoCard(
                    title: 'Mudanzas',
                    text: 'Mudanzas y minimudanzas',
                    picture: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Servicio de mudanzas y minimudanzas dentro de: PBA, CABA, desde Buenos Aires a todo el país.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  InfoCard(
                    title: 'Logística para empresas',
                    text: 'Ayudar es un viaje',
                    picture: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Tenemos la solución logística para empresas y PyMES, brindando los servicios de motomensajeria, cadetería, mudanzas y traslados.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        ),
      ],
    );
  }

  _infoSection() {
    return Column(
      children: [
        Text(
          'Seguridad y pagos',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w600,
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
                      'assets/images/landing/vtv-logo.png',
                      height: 100,
                    ),
                  ),
                  InfoCard(
                    title: 'Somos Seguros',
                    text: 'Nuestra flota cuenta con póliza de seguro y seguro de carga',
                    picture: Image.asset(
                      'assets/images/landing/seguros-logo.png',
                      height: 120,
                    ),
                  ),
                  InfoCard(
                    title: '¿Cómo pagar?',
                    text: 'Efectivo, transferencia bancaria, Mercado Pago y pago electrónico',
                    picture: Image.asset(
                      'assets/images/landing/mp-logo.png',
                      height: 120,
                    ),
                  ),
                ],
              )
          ),
        ),
      ],
    );
  }

  _companiesSection(double deviceWidth) {
    return Column(
      children: [
        Text(
          'Empresas que confían en nosotros',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        CarouselSlider(
            options: CarouselOptions(
                height: 240.0,
                viewportFraction: deviceWidth > 860 ? 0.25 :
                (deviceWidth > 480 ? 0.4 : 0.5)
            ),
            items: [
              Image.asset(
                'assets/images/landing/farmacity-logo.png',
                width: 180,
              ),
              Image.asset(
                'assets/images/landing/lomanegra-logo.png',
                width: 140,
              ),
              Image.asset(
                'assets/images/landing/redbull-logo.png',
                width: 180,
              ),
              Image.asset(
                'assets/images/landing/welivery-logo.png',
                width: 180,
              ),
            ]
        ),
      ],
    );
  }
}