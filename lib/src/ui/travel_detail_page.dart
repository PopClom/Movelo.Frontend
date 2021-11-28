import 'package:fletes_31_app/src/blocs/travel_detail_bloc.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/ui/components/map_view.dart';
import 'package:fletes_31_app/src/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
}