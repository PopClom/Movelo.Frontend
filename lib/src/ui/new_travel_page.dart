import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'components/location_autocomplete_selector.dart';
import 'components/transport_type_selector.dart';

class NewTravelPage extends StatefulWidget {
  @override
  _NewTravelPageState createState() => _NewTravelPageState();
}

class _NewTravelPageState extends State<NewTravelPage> {
  GooglePlacesDetails originPlace;
  GooglePlacesDetails destinationPlace;
  VehicleType selectedVehicleType;
  bool requiresLoading = false;

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

  bool formCompleted() {
    return
      originPlace != null &&
          destinationPlace != null &&
          selectedVehicleType != null;
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 15,
        children: [
          TransportTypeSelector(
            onSelectionChanged: (vehicleType) {
              setState(() {
                selectedVehicleType = vehicleType;
              });
            },
          ),
          LocationAutocompleteSelector(
            label: "¿Desde dónde?",
            prefixIcon: Icon(Icons.my_location, color: Colors.blue,),
            onLocationSelected: (place) {
              setState(() {
                originPlace = place;

                mapMarkers["Origen"] = new Marker(
                  markerId: MarkerId("Origen_${DateTime.now().millisecondsSinceEpoch}"),
                  position: LatLng(place.geometry.location.lat, place.geometry.location.lng),
                  infoWindow: InfoWindow(
                    title: "Origen",
                    snippet: place.name,
                  ),
                );

                if(originPlace != null && destinationPlace != null)
                  updateCameraLocation(mapMarkers["Origen"].position, mapMarkers["Destino"].position, mapController);
                else
                  updateCameraLocation(mapMarkers.values.first.position, mapMarkers.values.first.position, mapController);
              });
            },
          ),
          LocationAutocompleteSelector(
            label: "¿Hasta dónde?",
            prefixIcon: Icon(Icons.location_pin, color: Colors.red,),
            onLocationSelected: (place) {
              setState(() {
                destinationPlace = place;

                mapMarkers["Destino"] = new Marker(
                  markerId: MarkerId("Destino${DateTime.now().millisecondsSinceEpoch}"),
                  position: LatLng(place.geometry.location.lat, place.geometry.location.lng),
                  infoWindow: InfoWindow(
                    title: "Destino",
                    snippet: place.name,
                  ),
                );

                if(originPlace != null && destinationPlace != null)
                  updateCameraLocation(mapMarkers["Origen"].position, mapMarkers["Destino"].position, mapController);
                else
                  updateCameraLocation(mapMarkers.values.first.position, mapMarkers.values.first.position, mapController);
              });
            },
          ),
          CheckboxListTile(
              title: Text("Requiero que el fletero realice la carga y descarga de los articulos transportados"),
              value: requiresLoading,
              onChanged: (val) {
                setState(() {
                  requiresLoading = val;
                });
              }
          ),
          SizedBox(
              width: double.infinity,
              // height: double.infinity,
              child: ElevatedButton(
                  onPressed: !formCompleted() ? null : () {},
                  child: Text("Cotizar")
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
