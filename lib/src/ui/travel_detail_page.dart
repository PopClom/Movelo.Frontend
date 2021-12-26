import 'package:fletes_31_app/src/utils/whatsapp.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:fletes_31_app/src/blocs/travel_detail_bloc.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/ui/components/map_view.dart';
import 'package:fletes_31_app/src/utils/helpers.dart';
import 'package:fletes_31_app/src/blocs/auth_bloc.dart';

class TravelDetailPage extends StatefulWidget {
  static const routeName = '/travels/:id/';

  final int id;

  TravelDetailPage(this.id, { Key key }) : super(key: key);

  @override
  _TravelDetailPageState createState() => _TravelDetailPageState();
}

class _TravelDetailPageState extends State<TravelDetailPage> {
  final TravelDetailBloc bloc = TravelDetailBloc();
  bool scrollMap = true;

  @override
  void initState() {
    bloc.fetchTravel(widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return SlidingUpPanel(
      backdropEnabled: true,
      panelBuilder: (sc) => _panel(sc),
      onPanelSlide: (double position) {
        if (scrollMap && position > 0) {
          setState(() {
            scrollMap = false;
          });
        }
      },
      onPanelClosed: () {
        setState(() {
          scrollMap = true;
        });
      },
      body: MapView(
        scrollable: scrollMap,
        markers: bloc.originAndDestinationMarkers,
      ),
      borderRadius: radius,
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: StreamBuilder<Travel>(
            stream: bloc.travel,
            builder: (context, snap) {
              if (snap.hasData) {
                Travel travel = snap.data;
                return ListView(
                  controller: sc,
                  children: <Widget>[
                    SizedBox(
                      height: 12.0,
                    ),
                    _buildGrip(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.network(
                            'https://movelo.com.ar' + travel.requestedVehicleType.imageUrl,
                            height: 60,
                            width: 60,
                            fit: BoxFit.contain,
                            color: Colors.deepPurple
                        ),
                        SizedBox(
                          width: 24.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${travel.estimatedPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 24.0,
                                height: 0.9,
                              ),
                            ),
                            Text(
                              travel.status.label,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _buildDescription('Origen', travel.origin.name),
                    _buildDescription('Destino', travel.destination.name),
                    _buildDescription('Estado del envío', travel.status.label),
                    _buildDescription(
                        'Detalle del envío',
                        'Vehículo: ${travel.requestedVehicleType.name}\n'
                            'El fletero carga: ${booleanToWord(travel.driverHandlesLoading)}\n'
                            'El fletero descarga: ${booleanToWord(travel.driverHandlesUnloading)}\n'
                            'Asistentes: ${travel.requiredAssistants}\n'
                            'Entra en el ascensor: ${booleanToWord(travel.fitsInElevator)}\n'
                            'Cantidad de pisos: ${travel.numberOfFloors}'
                    ),
                    _buildDescription('Detalle de la carga', travel.transportedObjectDescription),
                    _buildDescription('Medio de pago', 'En efectivo'),
                    SizedBox(height: 20.0),
                    _buildActionButton(travel),
                    SizedBox(height: 18.0),
                    authBloc.isClient() ? _getContactUsButton() : Container(),
                    SizedBox(
                      height: 24,
                    ),
                  ],
                );
              } else {
                return ListView(
                  controller: sc,
                  children: <Widget>[
                    SizedBox(
                      height: 12.0,
                    ),
                    _buildGrip(),
                    SizedBox(
                      height: 25.0,
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              }
            }
        ),
    );
  }

  Widget _buildGrip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
        ),
      ],
    );
  }

  Widget _buildDescription(String title, String description) {
    return Container(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 28.0,
          ),
          Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              )),
          SizedBox(
            height: 8.0,
          ),
          Text(description != null ? description : ''),
        ],
      ),
    );
  }

  Widget _buildActionButton(Travel travel) {
    if ((authBloc.isDriver() && travel.status != TravelStatus.Completed) ||
        (authBloc.isClient() && travel.status == TravelStatus.PendingDriver)) {
      return StreamBuilder<bool>(
          stream: bloc.isSubmitting,
          builder: (context, snap) {
            bool isSubmitting = (snap.hasData && snap.data != null && snap.data);
            return TextButton(
              onPressed: _getOnPressedForTravel(travel),
              child: Container(
                height: 40,
                width: 180,
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(2, 4),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                    color: isSubmitting ? Colors.grey.shade300 : (
                        authBloc.isDriver() ? Colors.deepPurple : Colors.pink
                    )
                ),
                child: !isSubmitting ? Text(
                  _getButtonWordingForTravel(travel),
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ) : SizedBox(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                  height: 20.0,
                  width: 20.0,
                ),
              ),
            );
          }
      );
    }

    return Container();
  }

  void Function() _getOnPressed(String title, String body, void Function() actionYes) {
    return () async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(body),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Sí'),
                onPressed: ()  {
                  actionYes();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    };
  }

  void Function() _getOnPressedForTravel(Travel travel) {
    if (authBloc.isDriver()) {
      if (travel.status == TravelStatus.PendingDriver) {
        return _getOnPressed(
          'Confirmá tu selección',
          '¿Estás seguro de que querés aceptar este envío?',
              () => bloc.claimTravel(travel.id),
        );
      } else if (travel.status == TravelStatus.ConfirmedAndPendingStart) {
        return _getOnPressed(
          'Confirmá tu selección',
          '¿Estás seguro de que querés iniciar este envío?',
              () => bloc.startTravel(travel.id),
        );
      } else if (travel.status == TravelStatus.InProgress) {
        return _getOnPressed(
          'Confirmá tu selección',
          '¿Estás seguro de que querés finalizar este envío?',
              () => bloc.endTravel(travel.id),
        );
      }
    }
    return _getOnPressed(
      'Confirmá tu selección',
      '¿Estás seguro de que querés cancelar este envío?',
          () => bloc.cancelTravel(travel.id),
    );
  }

  String _getButtonWordingForTravel(Travel travel) {
    if (authBloc.isDriver()) {
      if (travel.status == TravelStatus.PendingDriver) {
        return 'Aceptar envío';
      } else if (travel.status == TravelStatus.ConfirmedAndPendingStart) {
        return 'Iniciar envío';
      } else if (travel.status == TravelStatus.InProgress) {
        return 'Finalizar envío';
      }
    }
    return 'Cancelar envío';
  }

  Widget _getContactUsButton() {
    return Column(
        children: [
          Text(
            '¿Tenés un problema? ¡Contactanos!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 6),
          Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/contactus/whatsapp-logo.png',
                            height: 30.0,
                          ),
                          SizedBox(width: 10), Text(
                            '11 5842-4244',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        sendWhatsAppMessage("5491158424244", "");
                      },
                    )
                ),
              ],
            ),
          ),
        ]
    );
  }
}