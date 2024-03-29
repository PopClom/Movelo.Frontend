import 'package:flutter/material.dart';
import 'package:fletes_31_app/src/ui/fragments/footer_fragment.dart';

class ContactUsPage extends StatefulWidget {
  static const routeName = '/contactanos';

  const ContactUsPage({Key key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(10, 0, 0, 0),
      child: Column(
          children: [
            SizedBox(height: 60),
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
                          SelectableText(
                            'hola.movelo@gmail.com',
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
                            'assets/images/contactus/instagram-logo.png',
                            height: 40,
                          ),
                          SizedBox(width: 15),
                          SelectableText(
                            '@movelo.ar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ]
      ),
    );
  }
}