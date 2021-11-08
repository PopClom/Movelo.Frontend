// import 'package:animation_wrappers/animation_wrappers.dart';
import 'dart:math';
import 'package:fletes_31_app/src/blocs/travels_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';

class MyOrderItem {
  MyOrderItem(this.img, this.name);
  String img;
  String name;
}

class TravelsPage extends StatefulWidget {
  static const routeName = '/travels';

  @override
  _TravelsPageState createState() => _TravelsPageState();
}

class _TravelsPageState extends State<TravelsPage> {
  @override
  Widget build(BuildContext context) {
    final TravelsBloc bloc = TravelsBloc();

    final deviceSize = MediaQuery.of(context).size;
    final width = min(deviceSize.width, 560.0);

    bloc.fetchTravels();

    return Container(
        alignment: Alignment.center,
        child: Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: 6),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Text(
                      "Solicitudes",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25
                      )
                  ),
                ),
                StreamBuilder<List<Travel>>(
                    stream: bloc.travels,
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snap.data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return buildCompleteCard(context, snap.data[index]);
                            });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                ),
              ],
              //),
              // beginOffset: Offset(0, 0.3),
              // endOffset: Offset(0, 0),
              // slideCurve: Curves.linearToEaseOut,
            ),
        )//FadedSlideAnimation(
      );
  }

  GestureDetector buildCompleteCard(BuildContext context, Travel travel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => null)
        );
      },
      child: Card(
        elevation: 8,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none
        ),
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(8)),
                color: Colors.deepPurple,
              ),
              child: buildItem(context, travel),
            ),
            buildOrderInfoRow(context, travel),
          ],
        ),
      ),
    );
  }

  Container buildOrderInfoRow(BuildContext context, Travel travel, {double borderRadius = 8}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(borderRadius)),
        color: Colors.grey[100],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12),
      child: Row(
        children: [
          buildGreyColumn(context, 'Pago', '\$${travel.estimatedPrice.toStringAsFixed(2)}'),
          Spacer(),
          buildGreyColumn(context, 'Medio de pago', 'En efectivo'),
          Spacer(),
          buildGreyColumn(context, 'Estado del pedido', travel.status.label,
              text2Color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }

  Padding buildItem(BuildContext context, Travel travel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/map_icon.png',
                    height: 60,
                    width: 60,
                    fit: BoxFit.fill,
                  )),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Origen: ' + (travel.origin.name != null ? travel.origin.name : 'Desconocido'),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 15, color: Colors.white),
                  ),
                  Text(
                    'Destino: ' + (travel.destination.name != null ? travel.destination.name : 'Desconocido'),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 15, color: Colors.white),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "07/11/2021 a las 13.45",
                    style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white70),
                  ),
                  SizedBox(height: 16),
                  Text('Duración estimada: 55 minutos (5.3km)',
                      style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white70)
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding buildAmountRow(String name, String price,
      {FontWeight fontWeight = FontWeight.w500}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: fontWeight),
          ),
          Spacer(),
          Text(
            price,
            style: TextStyle(fontWeight: fontWeight),
          ),
        ],
      ),
    );
  }

  Column buildGreyColumn(BuildContext context, String text1, String text2,
      {Color text2Color = Colors.black}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text1,
            style: Theme.of(context).textTheme.subtitle2
        ),
        SizedBox(height: 8),
        LimitedBox(
          child: Text(text2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: text2Color)
          ),
        ),
      ],
    );
  }
}
