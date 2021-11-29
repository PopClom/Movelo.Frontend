import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class InfoCard extends StatefulWidget{
  final String title;
  final String text;
  final Widget picture;

  InfoCard({
    this.title,
    this.text,
    this.picture,
  });

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container (
      width: 320,
      height: 350,
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Image.asset(
                'assets/images/ornaments/smile-fluor.png',
                height: 25,
              ),
              SizedBox(height: 20),
              Text(widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              widget.picture,
            ],
          ),
        ),
      ),
    );
  }
}