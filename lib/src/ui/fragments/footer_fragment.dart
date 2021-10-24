import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            'assets/images/footer.png',
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
                        SelectableText(
                          'hola.movelo@gmail.com',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SelectableText(
                          '@movelo.ar',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
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
