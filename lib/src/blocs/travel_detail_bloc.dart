import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fletes_31_app/src/network/travel_api.dart';

class TravelDetailBloc {
  final apiService = TravelAPI(Dio());

  final BehaviorSubject<Travel> _travel = BehaviorSubject<Travel>();

  Stream<List<Marker>> get originAndDestinationMarkers => _travel.map((travel) {
    return [
      _locationToMarker(travel.origin, "Origen"),
      _locationToMarker(travel.destination, "Destino"),
    ];
  });

  BehaviorSubject<Travel> get travel => _travel;

  Future<void> fetchTravel(int id) async {
    Travel travel = await apiService.getTravelById(id);
    /*Travel travel = Travel(
      id: 1,
      requestingUserId: 1,
      requestedVehicleType: VehicleType(name: "Auto", imageUrl: "/resources/vehicle-images/auto.png"),
      status: TravelStatus.PendingDriver,
      driverId: 1,
      origin: Location(name: "Helguera 1323, CABA, dasdsa, adssad, adsads, adsdsa, dsadas"),
      destination: Location(name: "Monroe 1161, CABA"),
      estimatedPrice: 3550.00,
      estimatedRoute: Route(
        distanceInMeters: 19000,
        travelTimeInSeconds: 360,
      ),
    );*/
    _travel.sink.add(travel);
  }

  Marker _locationToMarker(Location location, String name) {
    return new Marker(
      markerId: MarkerId("${name}_${DateTime.now().millisecondsSinceEpoch}"),
      position: LatLng(location.lat, location.lng),
      infoWindow: InfoWindow(
        title: name,
        snippet: location.name.split(",")[0],
      ),
    );
  }

  dispose() {
    _travel.close();
  }
}