import 'package:fletes_31_app/src/blocs/new_travel_bloc.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:fletes_31_app/src/ui/landing_page.dart';
import 'package:fletes_31_app/src/utils/new_travel_args.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:async/async.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'components/location_autocomplete_selector.dart';
import 'components/transport_type_info.dart';
import 'components/transport_type_selector.dart';

class NewTravelPage extends StatefulWidget {
  static const routeName = '/cotizar';

  NewTravelPage({ Key key }) : super(key: key);

  @override
  _NewTravelPageState createState() => _NewTravelPageState();
}

class _NewTravelPageState extends State<NewTravelPage> {
  final NewTravelBloc bloc = NewTravelBloc();

  Map<String, Marker> mapMarkers = new Map();
  GoogleMapController mapController;
  CancelableOperation travelEstimation;

  String _initialOriginString;
  String _initialDestinationString;
  bool _initialArgsLoaded;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    bloc.informMapLoaded(true);
  }

  Future<void> updateCameraLocation(
      LatLng source,
      LatLng destination,
      GoogleMapController mapController,
      ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

  @override
  void initState() {
    bloc.originAndDestinationMarkers.listen((List<Marker> markerList) {
      if(markerList.isNotEmpty) {
        updateCameraLocation(markerList[0].position, markerList.length == 2 ? markerList[1].position : markerList[0].position, mapController);
      }
    });

    bloc.formCompleted.listen((completed) async {
      if (travelEstimation != null) {
        travelEstimation.cancel();
        bloc.changeIsSubmitting(false);
      }

      if(completed == true) {
        travelEstimation =  CancelableOperation.fromFuture(
            bloc.submit()
        );
        bloc.changeIsSubmitting(true);
        travelEstimation.then((estimation) {
          bloc.changeCurrentTravelEstimation(estimation);
          bloc.changeIsSubmitting(false);
        });
      } else {
        bloc.changeCurrentTravelEstimation(null);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    double mapSize = deviceSize.width * 0.35;

    final args = ModalRoute.of(context).settings.arguments as NewTravelArgs;
    if (args != null && !_initialArgsLoaded) {
      _initialOriginString = args.originPlacesDetails.formattedAddress;
      _initialDestinationString = args.destinationPlacesDetails.formattedAddress;
      bloc.changeOriginPlacesDetails(args.originPlacesDetails);
      bloc.changeDestinationPlacesDetails(args.destinationPlacesDetails);
      bloc.changeSelectedVehicleType(args.selectedVehicleType);
    } else {
      _initialOriginString = null;
      _initialDestinationString = null;
    }
    _initialArgsLoaded = true;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: deviceSize.width * 0.04),
      child: ListView(
        children: [
          Center(
            child: Text(
                "Cotizá tu viaje con nosotros",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 30
                )
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Flexible(
                child: Column(
                  children: [
                    Text(
                        "¿Qué vas a cargar?",
                        style: TextStyle(
                            fontWeight: FontWeight.w600
                        )
                    ),
                    TextField(
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      onChanged: bloc.changeTransportedObjectsDetails,
                      autofocus: true,
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 10.0
                          ),
                          hintText: "Cinco macetas grandes",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          //prefixIcon: this.widget.prefixIcon,
                          fillColor: Colors.white,
                          filled: true
                      ),
                    ),
                    SizedBox(height: 9),
                    Text(
                        "Origen de carga",
                        style: TextStyle(
                            fontWeight: FontWeight.w600
                        )
                    ),
                    LocationAutocompleteSelector(
                      label: "Origen de carga",
                      onLocationSelected: bloc.changeOriginPlacesDetails,
                      initialValue: _initialOriginString,
                    ),
                    SizedBox(height: 10),
                    Text(
                        "Destino de carga",
                        style: TextStyle(
                            fontWeight: FontWeight.w600
                        )
                    ),
                    LocationAutocompleteSelector(
                      label: "Destino de carga",
                      onLocationSelected: bloc.changeDestinationPlacesDetails,
                      initialValue: _initialDestinationString,
                    ),
                    SizedBox(height: 10),
                    Text(
                        "¿Qué vehículo necesitás para transportar tu carga?",
                        style: TextStyle(
                            fontWeight: FontWeight.w600
                        )
                    ),
                    StreamBuilder(
                        stream: bloc.selectedVehicleType,
                        builder: (context, snapshot) {
                          if(snapshot.hasData && !snapshot.hasError) {
                            return TransportTypeInformation(
                                vehicleType: snapshot.data,
                                onChangeClicked: () => bloc.changeSelectedVehicleType(null)
                            );
                          } else {
                            return Container(
                                alignment: Alignment.center,
                                child:
                                  TransportTypeSelector(
                                      onSelectionChanged: (vehicleType) => bloc.changeSelectedVehicleType(vehicleType)
                                  )
                            );
                          }
                        }
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder(
                              stream: bloc.driverLoadingAndUnloadingIntStatus,
                              builder: (context, snapshot) {
                                return DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    labelText: 'El fletero...',
                                    labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, height: 1.2),
                                    isDense: true,
                                  ),
                                  onChanged: (value) {
                                    bloc.changeDriverLoadingAndUnloadingIntStatus(value);
                                    if(value == 1) {
                                      bloc.changeDriverHandlesLoading(true);
                                      bloc.changeDriverHandlesUnloading(false);
                                    } else if(value == 2) {
                                      bloc.changeDriverHandlesLoading(false);
                                      bloc.changeDriverHandlesUnloading(true);
                                    } else if(value == 3) {
                                      bloc.changeDriverHandlesLoading(true);
                                      bloc.changeDriverHandlesUnloading(true);
                                    } else if(value == 4) {
                                      bloc.changeDriverHandlesLoading(false);
                                      bloc.changeDriverHandlesUnloading(false);
                                    }
                                  },
                                  value: snapshot.data,
                                  items: [
                                    DropdownMenuItem(child: Text("Carga"), value: 1),
                                    DropdownMenuItem(child: Text("Descarga"), value: 2),
                                    DropdownMenuItem(child: Text("Carga y descarga"), value: 3),
                                    DropdownMenuItem(child: Text("NO carga NI descarga"), value: 4),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 12),
                            StreamBuilder(
                              stream: bloc.fitsInElevator,
                              builder: (context, snapshot) {
                                return DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Entra en el ascensor',
                                    labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, height: 1.2),
                                    isDense: true,
                                  ),
                                  onChanged: (value) => bloc.changeFitsInElevator(value == 2),
                                  value: snapshot.hasData && snapshot.data ? 2 : 1,
                                  items: [
                                    DropdownMenuItem(child: Text("No"), value: 1),
                                    DropdownMenuItem(child: Text("Sí"), value: 2),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),),
                        SizedBox(width: 15),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Cantidad de ayudantes',
                                labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, height: 1.2),
                                isDense: true,
                              ),
                              onChanged: (value) => bloc.changeNumberOfHelpers(value),
                              items: [
                                DropdownMenuItem(child: Text("0"), value: 0),
                                DropdownMenuItem(child: Text("1"), value: 1),
                                DropdownMenuItem(child: Text("2"), value: 2),
                              ],
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Cantidad de pisos',
                                  labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, height: 1.3),
                                  isDense: true,
                                ),
                                onChanged: (val) => bloc.changeNumberOfFloors(int.tryParse(val)),
                                keyboardType: TextInputType.number
                            )
                          ],
                        ),)
                      ],
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  LandingPage.routeName,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Text("CANCELAR PEDIDO", style: TextStyle(color: Colors.black)),
                              )
                          ),
                          SizedBox(width: 10),
                          StreamBuilder(
                            stream: bloc.currentTravelEstimation,
                            builder: (context, snap1) {
                              return StreamBuilder<bool>(
                                  stream: bloc.isSubmitting,
                                  builder: (context, snap2) {
                                    return Container(
                                      child: Expanded(child: ElevatedButton(
                                        onPressed: snap1.hasData && snap1.data != null
                                            && !(snap1.hasData && snap1.data != null && snap2.data)
                                            ? bloc.confirmTravelRequest : null,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          child: (snap2.hasData && snap2.data != null && snap2.data ?
                                          SizedBox(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                            ),
                                            height: 20.0,
                                            width: 20.0,
                                          ) : Text("REALIZAR PEDIDO")),
                                        ),
                                      )),
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              SizedBox(width: 30),
              Container(
                height: mapSize,
                width: mapSize,
                child: Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      foregroundDecoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 96,46,209),
                              width: 1.5
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 96,46,209),
                              width: 1.5
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: StreamBuilder(
                        stream: bloc.originAndDestinationMarkers,
                        builder: (context, snapshot) {
                          List<Marker> markerList = snapshot.data;
                          return GestureDetector(
                              onVerticalDragUpdate: (_) {},
                              child: GoogleMap(
                                markers: markerList != null ? markerList.toSet() : {},
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: const LatLng(-34.60360641689277, -58.381548944057414),
                                  zoom: 13,
                                ),
                              ),
                          );
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Wrap(
                            children: [
                              Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromARGB(255, 96,46,209),
                                        width: 3
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: Colors.white
                                ),
                                child: IntrinsicWidth(child: StreamBuilder(
                                  stream: bloc.currentTravelEstimation,
                                  builder: (context, snapshot) {
                                    Travel travelEstimation = snapshot.data;

                                    if(snapshot.hasData && !snapshot.hasError && snapshot.data != null) {
                                      return Column(
                                        children: [
                                          Container(
                                              color: Color.fromARGB(255, 96,46,209),
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: StreamBuilder(
                                                    stream: bloc.selectedVehicleType,
                                                    builder: (context, snapshot) {
                                                      if(snapshot.hasData && !snapshot.hasError) {
                                                        VehicleType selectedVehicleType = snapshot.data;

                                                        return Row(
                                                          children: [
                                                            Image.network(
                                                                "http://movelo-001-site1.htempurl.com" + selectedVehicleType.imageUrl,
                                                                height: 35,
                                                                fit: BoxFit.contain,
                                                                color: Colors.white
                                                            ),
                                                            Expanded(child: Text(
                                                              '\$${travelEstimation.estimatedPrice.toStringAsFixed(2)}',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w600
                                                              ),
                                                            ))
                                                          ],
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    }
                                                ),
                                              )
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.timer,
                                                  color: Color.fromARGB(255, 96,46,209),
                                                ),
                                                SizedBox(width: 10),
                                                Text("Tiempo estimado: ${(travelEstimation.estimatedRoute.travelTimeInSeconds / 60.0).toStringAsFixed(0)} minutos")
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.square_foot,
                                                  color: Color.fromARGB(255, 96,46,209),
                                                ),
                                                SizedBox(width: 10),
                                                Text("Distancia a recorrer: ${(travelEstimation.estimatedRoute.distanceInMeters / 1000.0).toStringAsFixed(1)}km")
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container(
                                          color: Color.fromARGB(255, 96,46,209),
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Center(
                                              child: Text(
                                                "Por favor, complete el formulario.",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ),
                                          )
                                      );
                                    }
                                  },
                                )),
                              ),
                            ],
                          )
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
