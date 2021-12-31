import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final Stream<List<Marker>> markers;
  final bool scrollable;
  final Function(GoogleMapController controller) onMapCreated;

  MapView({
    this.markers,
    this.scrollable = true,
    this.onMapCreated,
  });

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController mapController;
  List<Marker> markerList;

  @override
  Widget build(BuildContext context) {
    Function(GoogleMapController) onMapCreated = widget.onMapCreated != null ? (controller) {
      widget.onMapCreated(controller);
      _onMapCreated(controller);
    } : _onMapCreated;

    CameraPosition initialCameraPosition = CameraPosition(
      target: const LatLng(-34.60360641689277, -58.381548944057414),
      zoom: 13,
    );

    if (widget.markers != null) {
      return GoogleMap(
        scrollGesturesEnabled: widget.scrollable,
        markers: markerList != null ? markerList.toSet() : {},
        onMapCreated: onMapCreated,
        initialCameraPosition: initialCameraPosition,
      );
    } else {
      return GoogleMap(
        scrollGesturesEnabled: widget.scrollable,
        markers: {},
        onMapCreated: onMapCreated,
        initialCameraPosition: initialCameraPosition,
      );
    }
  }

  @override
  void dispose() {
    if (mapController != null)
      mapController.dispose();
    super.dispose();
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


  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    widget.markers.listen((List<Marker> markerList) {
      if (markerList.isNotEmpty) {
        if (this.markerList == null) {
          updateCameraLocation(
              markerList[0].position,
              markerList.length >= 2 ? markerList[1].position : markerList[0].position,
              mapController
          );
        }

        setState(() {
          this.markerList = markerList;
        });
      }
    });
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
}
