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
                  child: Text('Solicitudes',
                      style: Theme.of(context)
                          .textTheme
                          .headline3
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
                        return Container();
                      }
                    }
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => null));
                  },
                  child: Card(
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    margin: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    color: Colors.white,
                    elevation: 1,
                    child: Column(
                      children: [
                        Padding(
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
                                        height: 70,
                                        width: 70,
                                        fit: BoxFit.fill,
                                      )),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Origen: Av. Córdoba 2190, CABA',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 15),
                                      ),
                                      Text(
                                        'Destino: Juan B. Justo 576, CABA',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 15),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Flete mediano',
                                        style: Theme.of(context).textTheme.subtitle2,
                                      ),
                                      Text('Duración estimada: 43 minutos (4.8km)',
                                          style: Theme.of(context).textTheme.subtitle2
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(8)),
                            color: Colors.grey[100],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12),
                          child: Row(
                            children: [
                              buildGreyColumn(context, 'Pago', '\$${3400}'),
                              Spacer(),
                              buildGreyColumn(context, 'Medio de pago', 'En efectivo'),
                              Spacer(),
                              buildGreyColumn(context, 'Estado del pedido', 'Confirmado',
                                  text2Color: Theme.of(context).primaryColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
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
            context, MaterialPageRoute(builder: (context) => null));
      },
      child: Card(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none),
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        color: Colors.white,
        elevation: 1,
        child: Column(
          children: [
            buildItem(context, travel),
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
          buildGreyColumn(context, 'Estado del pedido', /*travel.status.label*/"asd",
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
                    height: 70,
                    width: 70,
                    fit: BoxFit.fill,
                  )),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Origen: Av. del Libertador 2417, CABA',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 15),
                  ),
                  Text(
                    'Destino: Helguera 1323, CABA',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 15),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Flete mediano',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 16),
                  Text('Duración estimada: 55 minutos (5.3km)',
                      style: Theme.of(context).textTheme.subtitle2
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


/*

CircleAvatar buildStatusIcon(IconData icon, {bool disabled = false}) =>
      CircleAvatar(
          backgroundColor: !disabled ? Color(0xff222e3e) : Colors.grey[300],
          child: Icon(
            icon,
            size: 20,
            color: !disabled
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
          ));

* Card(
              elevation: 3,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              margin: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              color: Colors.white,
              child: Column(
                children: [
                  buildItem(context, 'assets/images/seller1.png', 'Ni idea',
                      '2 items'),
                  buildOrderInfoRow(context, '\$30.50', 'En efectivo',
                      'En camino',
                      borderRadius: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildStatusIcon(Icons.done_all),
                            Text('------'),
                            buildStatusIcon(Icons.assignment_returned),
                            Text('------'),
                            buildStatusIcon(Icons.directions_bike),
                            Text('------'),
                            buildStatusIcon(Icons.navigation),
                            Text('------'),
                            buildStatusIcon(Icons.home, disabled: true),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Asignado' + '  ',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Empacando',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'En camino',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Localizar',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                ' ' + 'Entregado',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Items pedidos',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        buildAmountRow('Cebollas moradas frescas', '\$14.00'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Qnt. 1',
                            style: Theme.of(context).textTheme.subtitle2),
                        buildAmountRow('Dedos de dama frescos', '\$14.00'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Qnt. 1',
                            style: Theme.of(context).textTheme.subtitle2),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8, bottom: 10, top: 5),
                    child: Column(
                      children: [
                        buildAmountRow('Envio gratis', '\$4.50'),
                        buildAmountRow('Cupon de descuento', '-\$2.00'),
                        buildAmountRow('Total a pagar', '\$30.50',
                            fontWeight: FontWeight.w700),
                      ],
                    ),
                  )
                ],
              ),
            ),
* */