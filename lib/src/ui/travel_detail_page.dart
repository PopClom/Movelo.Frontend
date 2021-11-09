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
        markers: null,
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
                    _buildDescription('Medio de pago', 'En efectivo'),
                    SizedBox(
                      height: 28,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("About",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            """Pittsburgh is a city in the state of Pennsylvania in the United States, and is the county seat of Allegheny County. A population of about 302,407 (2018) residents live within the city limits, making it the 66th-largest city in the U.S. The metropolitan population of 2,324,743 is the largest in both the Ohio Valley and Appalachia, the second-largest in Pennsylvania (behind Philadelphia), and the 27th-largest in the U.S.\n\nPittsburgh is located in the southwest of the state, at the confluence of the Allegheny, Monongahela, and Ohio rivers. Pittsburgh is known both as "the Steel City" for its more than 300 steel-related businesses and as the "City of Bridges" for its 446 bridges. The city features 30 skyscrapers, two inclined railways, a pre-revolutionary fortification and the Point State Park at the confluence of the rivers. The city developed as a vital link of the Atlantic coast and Midwest, as the mineral-rich Allegheny Mountains made the area coveted by the French and British empires, Virginians, Whiskey Rebels, and Civil War raiders.\n\nAside from steel, Pittsburgh has led in manufacturing of aluminum, glass, shipbuilding, petroleum, foods, sports, transportation, computing, autos, and electronics. For part of the 20th century, Pittsburgh was behind only New York City and Chicago in corporate headquarters employment; it had the most U.S. stockholders per capita. Deindustrialization in the 1970s and 80s laid off area blue-collar workers as steel and other heavy industries declined, and thousands of downtown white-collar workers also lost jobs when several Pittsburgh-based companies moved out. The population dropped from a peak of 675,000 in 1950 to 370,000 in 1990. However, this rich industrial history left the area with renowned museums, medical centers, parks, research centers, and a diverse cultural district.\n\nAfter the deindustrialization of the mid-20th century, Pittsburgh has transformed into a hub for the health care, education, and technology industries. Pittsburgh is a leader in the health care sector as the home to large medical providers such as University of Pittsburgh Medical Center (UPMC). The area is home to 68 colleges and universities, including research and development leaders Carnegie Mellon University and the University of Pittsburgh. Google, Apple Inc., Bosch, Facebook, Uber, Nokia, Autodesk, Amazon, Microsoft and IBM are among 1,600 technology firms generating \$20.7 billion in annual Pittsburgh payrolls. The area has served as the long-time federal agency headquarters for cyber defense, software engineering, robotics, energy research and the nuclear navy. The nation's eighth-largest bank, eight Fortune 500 companies, and six of the top 300 U.S. law firms make their global headquarters in the area, while RAND Corporation (RAND), BNY Mellon, Nova, FedEx, Bayer, and the National Institute for Occupational Safety and Health (NIOSH) have regional bases that helped Pittsburgh become the sixth-best area for U.S. job growth.
                  """,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
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
          Text(description),
        ],
      ),
    );
  }
}