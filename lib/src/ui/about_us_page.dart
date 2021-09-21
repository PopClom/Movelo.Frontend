import 'dart:math';
import 'package:fletes_31_app/src/ui/fragments/footer_fragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fletes_31_app/src/ui/components/info_card.dart';

class AboutUsPage extends StatefulWidget {
  static const routeName = '/quienes-somos';

  const AboutUsPage({Key key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      child: ListView(
          children: [
            _aboutUsSection(deviceSize.width),
            SizedBox(height: 20),
            _ourServicesSection(),
            SizedBox(height: 40),
            Footer(),
          ]
      ),
    );
  }

  _aboutUsSection(double deviceWidth) {
    final width = min(deviceWidth * 0.85, 650);

    return Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            'assets/images/gray-ornament.png',
            fit: BoxFit.fitHeight,
            height: 700,
          ),
          Container(
            width: width,
            height: 650,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿Quiénes somos?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Somos la solución logística que estabas esperando, la combinación ideal entre compromiso social y movimiento.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Te ofrecemos una contratación fácil y flexible a través de nuestros 3 servicios principales: traslados, mudanzas y logística para empresas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Nos adaptamos a las necesidades de cada cliente y a las transformaciones que nos propone el entorno, ¡estamos listos con los motores en marcha!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Trabajamos con un objetivo en común: valorar lo que transportamos entendiendo el valor que tiene para vos que esto llegue en buenas condiciones y a tiempo.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Nuestros motores son la flexibilidad, el compañerismo, la confiabilidad y el compromiso.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.deepPurple,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ]
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
}