// import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';

class MyOrderItem {
  MyOrderItem(this.img, this.name);
  String img;
  String name;
}

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    List<MyOrderItem> myOrders = [
      MyOrderItem('images/Layer 1438.png', 'Helguera 1323 Dto 16, CABA'),
      MyOrderItem('images/Layer 1439.png', 'Granja Verde'),
      MyOrderItem('images/Garlic.png', 'Granja del ajo fresco'),
      MyOrderItem('images/Potatoes.png', 'Papas medianas'),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[200],
//      drawer: buildDrawer(context),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text('Mis pedidos'),
          centerTitle: true,
        ),
      ),
      body: //FadedSlideAnimation(
        ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Card(
              elevation: 3,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              margin: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              color: Colors.white,
              child: Column(
                children: [
                  buildItem(context, 'images/seller1.png', 'Ni idea',
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
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return buildCompleteCard(context, myOrders[index].img,
                      myOrders[index].name, 'Flete mediano');
                }),
          ],
        //),
        // beginOffset: Offset(0, 0.3),
        // endOffset: Offset(0, 0),
        // slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

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

  GestureDetector buildCompleteCard(
      BuildContext context, String img, String item, String category) {
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
            buildItem(context, img, item, category),
            buildOrderInfoRow(
                context, '\$30.50', 'En efectivo', 'Sin asignar'),
          ],
        ),
      ),
    );
  }

  Container buildOrderInfoRow(BuildContext context, String price,
      String paymentMode, String orderStatus,
      {double borderRadius = 8}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(borderRadius)),
        color: Colors.grey[100],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 12),
      child: Row(
        children: [
          buildGreyColumn(context, 'Pago', price),
          Spacer(),
          buildGreyColumn(context, 'Medio de pago', paymentMode),
          Spacer(),
          buildGreyColumn(context, 'Estado del pedido', orderStatus,
              text2Color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }

  Padding buildItem(
      BuildContext context, String img, String name, String category) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    img,
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
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 6),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 16),
                  Text('Pedido hace 5 minutos',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontSize: 12.5)),
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
            style:
                Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 12.5)),
        SizedBox(height: 8),
        LimitedBox(
          maxWidth: 100,
          child: Text(text2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: text2Color)),
        ),
      ],
    );
  }
}
