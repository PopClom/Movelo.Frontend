import 'package:fletes_31_app/src/ui/fragments/footer_fragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fletes_31_app/src/ui/components/info_card.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  static const routeName = '/quienes-somos';

  const AboutUsPage({Key key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ListView(
          children: [
            _aboutUsSection(),
            SizedBox(height: 30),
            _contactUsSection(),
            SizedBox(height: 60),
            Footer(),
          ]
      ),
    );
  }

  _aboutUsSection() {
    return Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            'assets/images/ornaments/gray-ornament-short.png',
            fit: BoxFit.fitHeight,
            height: 500,
          ),
          Column(
            children: [
              SizedBox(height: 20),
              Text(
                '¿Quiénes somos?',
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
                          title: 'Nuestra Logística',
                          text: '',
                          picture: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Somos la solución logística que estabas esperando, la combinación ideal entre compromiso social y movimiento.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        InfoCard(
                          title: 'Contratación',
                          text: '',
                          picture: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Te ofrecemos una contratación fácil y flexible a través de nuestros 3 servicios principales: traslados, mudanzas y logística para empresas.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        InfoCard(
                          title: 'Adaptabilidad',
                          text: '',
                          picture: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Nos adaptamos a las necesidades de cada cliente y a las transformaciones que nos propone el entorno, ¡Estamos listos con los motores en marcha!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        InfoCard(
                          title: 'Nuestro objetivo',
                          text: '',
                          picture: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Valorar lo que transportamos entendiendo el valor que tiene para vos que esto llegue en buenas condiciones y a tiempo.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ],
          ),
        ]
    );
  }

  _contactUsSection() {
    return Column(
        children: [
          Text(
            '¡Contactanos!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 60),
          Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/contactus/whatsapp-logo.png',
                          height: 40.0,
                        ),
                        SizedBox(width: 15),
                        SelectableText(
                          '11 5842-4244',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/contactus/email-logo.png',
                          height: 40,
                        ),
                        SizedBox(width: 15),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          child: Text(
                            'hola.movelo@gmail.com',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            const url = 'mailto:hola.movelo@gmail.com';
                            canLaunch(url).then((result) => {
                              if (result) {
                                launch(url)
                              }
                            });
                          },
                        ),
                      ],
                    )
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/contactus/instagram-logo.png',
                          height: 40,
                        ),
                        SizedBox(width: 15),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          child: Text(
                            '@movelo.ar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            const url = 'https://www.instagram.com/movelo.ar/';
                            canLaunch(url).then((result) => {
                              if (result) {
                                launch(url)
                              }
                            });
                          },
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        ]
    );
  }

}