import 'package:fletes_31_app/src/blocs/new_travel_bloc.dart';
import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'components/location_autocomplete_selector.dart';
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

    return Container(
      margin: const EdgeInsets.all(10),
      color: Color.fromRGBO(96, 46, 209, 1),
      child: Wrap(
        runSpacing: 15,
        children: [
          Row(
            children: [
              Expanded(child: Column(
                children: [
                  Text(
                    "¿Desde donde vas?",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  LocationAutocompleteSelector(
                    label: "¿Desde donde vas?",
                    prefixIcon: Icon(Icons.location_pin, color: Colors.black,),
                    onLocationSelected: bloc.changeOriginPlacesDetails,
                  ),
                ],
              )),
              Expanded(child: Column(
                children: [
                  Text(
                    "¿Hasta donde vas?",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  LocationAutocompleteSelector(
                    label: "¿Hasta donde vas?",
                    prefixIcon: Icon(Icons.location_pin, color: Colors.black,),
                    onLocationSelected: bloc.changeDestinationPlacesDetails,
                  ),
                ],
              ))
            ],
          ),
          TransportTypeSelector(
            onSelectionChanged: bloc.changeSelectedVehicleType,
          ),
          StreamBuilder<bool>(
              stream: bloc.requiresLoading,
              builder: (context, snap) {
                return CheckboxListTile(
                    title: Text("Requiero que el fletero realice la carga y descarga de los articulos transportados"),
                    value: snap.hasData && snap.data,
                    onChanged: bloc.changeRequiresLoading
                );
              }
          ),
          SizedBox(
              width: double.infinity,
              // height: double.infinity,
              child: StreamBuilder<bool>(
                  stream: bloc.formCompleted,
                  builder: (context, snap) {
                    return ElevatedButton(
                      onPressed: !(snap.hasData && snap.data) ? null : () {},
                      child: Text("Cotizar"),
                    );
                  }
              )
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: GoogleMap(
              markers: mapMarkers.values.toSet(),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: const LatLng(-34.60360641689277, -58.381548944057414),
                zoom: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
