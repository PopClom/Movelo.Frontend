import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            'assets/images/ornaments/footer.png',
            fit: BoxFit.fitHeight,
            height: 184,
          ),
          Column(
            children: [
              SizedBox(height: 70),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/images/logos/logo-movelo-small.png',
                      height: 45,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Text(
                            'hola.movelo@gmail.com',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
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
                        InkWell(
                          child: Text(
                            '@movelo.ar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
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
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                '© Movelo 2021. All Rights Reserved.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ]
    );
  }
}
