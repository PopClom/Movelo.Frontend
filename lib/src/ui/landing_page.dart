import 'dart:math';
import 'package:fletes_31_app/src/ui/fragments/footer_fragment.dart';
import 'package:fletes_31_app/src/ui/fragments/new_travel_fragment.dart';
import 'package:fletes_31_app/src/ui/components/info_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

    return Container(
        alignment: Alignment.center,
        child: ListView(
            children: [
              _newTravelSection(deviceSize.width),
              _stepsSection(deviceSize.width),
              SizedBox(height: 20),
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
    final width = min(deviceWidth * 0.95, 1000.0);

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Image.asset(
          'assets/images/landing-background.png',
          fit: BoxFit.cover,
          height: 650,
          width: deviceWidth,
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
    );
  }

  _stepsSection(double deviceWidth) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        deviceWidth > 860 ?
        Image.asset(
          'assets/images/pasos-desktop.png',
          fit: BoxFit.fitHeight,
          height: 500,
        ) : (deviceWidth > 620 ? Image.asset(
          'assets/images/pasos-tablet.png',
          fit: BoxFit.fitHeight,
          height: 915,
        ) : Image.asset(
          'assets/images/pasos-mobile.png',
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
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )
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
      ],
    );
  }
}