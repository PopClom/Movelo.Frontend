import 'package:fletes_31_app/src/blocs/new_travel_bloc.dart';
import 'package:fletes_31_app/src/blocs/new_travel_fragment_bloc.dart';
import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
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

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
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
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.originAndDestinationFilled.listen((result) {
      if(result)
        updateCameraLocation(mapMarkers["Origen"].position, mapMarkers["Destino"].position, mapController);
      else
        updateCameraLocation(mapMarkers.values.first.position, mapMarkers.values.first.position, mapController);
    });

    bloc.originPlacesDetails.listen((place) {
      mapMarkers["Origen"] = new Marker(
        markerId: MarkerId("Origen_${DateTime.now().millisecondsSinceEpoch}"),
        position: LatLng(place.geometry.location.lat, place.geometry.location.lng),
        infoWindow: InfoWindow(
          title: "Origen",
          snippet: place.name,
        ),
      );
    });

    bloc.destinationPlacesDetails.listen((place) {
      mapMarkers["Destino"] = new Marker(
        markerId: MarkerId("Destino${DateTime.now().millisecondsSinceEpoch}"),
        position: LatLng(place.geometry.location.lat, place.geometry.location.lng),
        infoWindow: InfoWindow(
          title: "Destino",
          snippet: place.name,
        ),
      );
    });

    //bloc.changeSelectedVehicleType(selectedVehicleType);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 150),
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
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(),
                    child: Padding(
                      padding: EdgeInsets.all(2),
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
                              "¿Desde donde vas?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600
                              )
                          ),
                          LocationAutocompleteSelector(
                            label: "¿Desde donde vas?",
                            onLocationSelected: bloc.changeOriginPlacesDetails,
                          ),
                          SizedBox(height: 10),
                          Text(
                              "¿Hasta donde vas?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600
                              )
                          ),
                          LocationAutocompleteSelector(
                              label: "¿Hasta donde vas?",
                              onLocationSelected: bloc.changeDestinationPlacesDetails
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
                                  return TransportTypeSelector(
                                      onSelectionChanged: (vehicleType) => bloc.changeSelectedVehicleType(vehicleType)
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
                                  Text("El Fletero..."),
                                  StreamBuilder(
                                    stream: bloc.driverLoadingAndUnloadingIntStatus,
                                    builder: (context, snapshot) {
                                      return DropdownButton(
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
                                  SizedBox(height: 10,),
                                  Text("Entra en el ascensor"),
                                  StreamBuilder(
                                    stream: bloc.fitsInElevator,
                                    builder: (context, snapshot) {
                                      return DropdownButton(
                                        onChanged: (value) => bloc.changeFitsInElevator(value == 2),
                                        value: snapshot.data ? 2 : 1,
                                        items: [
                                          DropdownMenuItem(child: Text("No"), value: 1),
                                          DropdownMenuItem(child: Text("Sí"), value: 2),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),),
                              SizedBox(width: 10,),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Cantidad de ayudantes"),
                                  TextField(
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                          isDense: true
                                      ),
                                      onChanged: (val) => bloc.changeNumberOfHelpers(int.tryParse(val)),
                                      keyboardType: TextInputType.number
                                  ),
                                  SizedBox(height: 10),
                                  Text("Cantidad de pisos"),
                                  TextField(
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                          isDense: true
                                      ),
                                      onChanged: (val) => bloc.changeNumberOfFloors(int.tryParse(val)),
                                      keyboardType: TextInputType.number
                                  )
                                ],
                              ),)
                            ],
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Row(
                              children: [
                                ElevatedButton(
                                    onPressed: () {},
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
                                  stream: bloc.formCompleted,
                                  builder: (context, snapshot) {
                                    return Container(
                                      child: Expanded(child: ElevatedButton(
                                        onPressed: snapshot.hasData && !snapshot.hasError && snapshot.data == true
                                            ? () async {
                                          Travel travel = await bloc.submit();
                                          print(travel.estimatedPrice);
                                        }
                                            : null,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          child: Text("REALIZAR PEDIDO"),
                                        ),
                                      )),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    )
                  ),
                )),
                SizedBox(width: 50),
                Expanded(
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
                          child: GoogleMap(
                            markers: mapMarkers.values.toSet(),
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: const LatLng(-34.60360641689277, -58.381548944057414),
                              zoom: 13,
                            ),
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
                                  child: IntrinsicWidth(
                                    child: StreamBuilder(
                                      stream: bloc.formCompleted,
                                      builder: (context, snapshot) {
                                        if(snapshot.hasData && !snapshot.hasError && snapshot.data == true) {
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
                                                                  SvgPicture.network(
                                                                      "https://localhost:44312" + selectedVehicleType.imageUrl,
                                                                      height: 25,
                                                                      fit: BoxFit.contain,
                                                                      color: Colors.white
                                                                  ),
                                                                  Expanded(child: Text(
                                                                    selectedVehicleType.name.toUpperCase(),
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
                                                    Text("Tiempo estimado: 20 minutos")
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
                                                    Text("Distancia a recorrer: 29.3km")
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
                                                  "Por favor, complete el formulario con datos válidos para obtener una cotización de su viaje.",
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
                                    ),
                                  )
                                ),
                              ],
                            )
                          ),
                        )
                      ],
                    )
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}
