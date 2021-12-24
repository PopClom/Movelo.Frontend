// import 'package:animation_wrappers/animation_wrappers.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fletes_31_app/src/blocs/auth_bloc.dart';
import 'package:fletes_31_app/src/blocs/travels_bloc.dart';
import 'package:fletes_31_app/src/ui/travel_detail_page.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';
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
  final TravelsBloc bloc = TravelsBloc();

  @override
  void initState() {
    bloc.fetchTravels();

    super.initState();
  }

    @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final width = min(deviceSize.width, 560.0);

    return Container(
        alignment: Alignment.center,
        child: Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: 6),
                authBloc.isDriver() ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Text(
                      'Solicitudes',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25
                      )
                  ),
                ) : Container(),
                authBloc.isDriver() ? StreamBuilder<List<Travel>>(
                    stream: bloc.potentialTravels,
                    builder: (context, snap) {
                      if (snap.hasData) {
                        if (snap.data.isEmpty) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 35.0),
                            child: Text(
                              'No hay solicitudes actualmente.\n¡Acá van a aparecer los pedidos de los clientes para que los aceptes!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snap.data.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return buildCompleteCard(context, snap.data[index]);
                              });
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                ) : Container(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Text(
                      'Mis envíos',
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
                        if (snap.data.isEmpty) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 35.0),
                            child: Text(
                              authBloc.isClient() ?
                              'No tenés envíos actualmente.\n¡Solicitá tu primer envío desde el cotizador!' :
                              'No tenés envíos actualmente.\n¡Acá van a aparecer los pedidos de los clientes que aceptaste!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snap.data.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return buildCompleteCard(context, snap.data[index]);
                              });
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                ),
                SizedBox(height: 6),
              ],
            ),
        )
      );
  }

  Widget buildCompleteCard(BuildContext context, Travel travel) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            Navigation.navigationKey.currentContext,
            TravelDetailPage.routeName.replaceAll(':id', travel.id.toString()),
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
          buildGreyColumn(context, 'Total', '\$${travel.estimatedPrice.toStringAsFixed(2)}'),
          Spacer(),
          buildGreyColumn(context, 'Medio de pago', 'En efectivo'),
          Spacer(),
          buildGreyColumn(context, 'Estado del envío', travel.status.label,
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
                    height: 50,
                    width: 50,
                    fit: BoxFit.fill,
                  )),
              SizedBox(width: 10),
              Expanded(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Origen: ' + (travel.origin.name != null ? travel.origin.name : 'Desconocido'),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      'Destino: ' + (travel.destination.name != null ? travel.destination.name : 'Desconocido'),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 14, color: Colors.white),
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
        SizedBox(height: 2),
        LimitedBox(
          child: Text(text2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: text2Color)
          ),
        ),
      ],
    );
  }
}
