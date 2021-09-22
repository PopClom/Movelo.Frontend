import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/models/travel_pricing_request_model.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:fletes_31_app/src/network/travel_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';

class NewTravelBloc {
  final apiService = TravelAPI(Dio());

  final BehaviorSubject<GooglePlacesDetails> _originPlacesDetails = BehaviorSubject<GooglePlacesDetails>();
  final BehaviorSubject<GooglePlacesDetails> _destinationPlacesDetails = BehaviorSubject<GooglePlacesDetails>();
  final BehaviorSubject<VehicleType> _selectedVehicleType = BehaviorSubject<VehicleType>();
  final BehaviorSubject<String> _transportedObjectsDetails = BehaviorSubject<String>();
  final BehaviorSubject<int> _numberOfHelpers = BehaviorSubject<int>();
  final BehaviorSubject<bool> _fitsInElevator = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<int> _numberOfFloors = BehaviorSubject<int>();
  final BehaviorSubject<bool> _driverHandlesLoading = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _driverHandlesUnloading = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<int> _driverLoadingAndUnloadingIntStatus = BehaviorSubject<int>.seeded(4);
  final BehaviorSubject<Travel> _currentTravelEstimation = BehaviorSubject<Travel>();
  //TODO evitar esta monstruosidad de dejar esto abierto
  final BehaviorSubject<bool> _mapLoaded = BehaviorSubject<bool>();
  
  Function(GooglePlacesDetails) get changeOriginPlacesDetails => _originPlacesDetails.sink.add;
  Function(GooglePlacesDetails) get changeDestinationPlacesDetails => _destinationPlacesDetails.sink.add;
  Function(VehicleType) get changeSelectedVehicleType => _selectedVehicleType.sink.add;
  Function(String) get changeTransportedObjectsDetails => _transportedObjectsDetails.sink.add;
  Function(int) get changeNumberOfHelpers => _numberOfHelpers.sink.add;
  Function(bool) get changeFitsInElevator => _fitsInElevator.sink.add;
  Function(int) get changeNumberOfFloors => _numberOfFloors.sink.add;
  Function(bool) get changeDriverHandlesLoading => _driverHandlesLoading.sink.add;
  Function(bool) get changeDriverHandlesUnloading => _driverHandlesUnloading.sink.add;
  Function(int) get changeDriverLoadingAndUnloadingIntStatus => _driverLoadingAndUnloadingIntStatus.sink.add;
  Function(Travel) get changeCurrentTravelEstimation => _currentTravelEstimation.sink.add;
  Function(bool) get informMapLoaded => _mapLoaded.sink.add;

  Stream<GooglePlacesDetails> get originPlacesDetails => _originPlacesDetails.stream;
  Stream<GooglePlacesDetails> get destinationPlacesDetails => _destinationPlacesDetails.stream;
  Stream<VehicleType> get selectedVehicleType => _selectedVehicleType.stream;
  Stream<String> get transportedObjectsDetails => _transportedObjectsDetails.stream;
  Stream<int> get numberOfHelpers => _numberOfHelpers.stream;
  Stream<bool> get fitsInElevator => _fitsInElevator.stream;
  Stream<int> get numberOfFloors => _numberOfFloors.stream;
  Stream<bool> get driverHandlesLoading => _driverHandlesLoading.stream;
  Stream<bool> get driverHandlesUnloading => _driverHandlesUnloading.stream;
  Stream<int> get driverLoadingAndUnloadingIntStatus => _driverLoadingAndUnloadingIntStatus.stream;
  Stream<Travel> get currentTravelEstimation => _currentTravelEstimation.stream;
  Stream<bool> get mapLoaded => _mapLoaded.stream;

  Stream<List<Marker>> get originAndDestinationMarkers => Rx.combineLatest3(originPlacesDetails, destinationPlacesDetails, mapLoaded,
          (GooglePlacesDetails origin, GooglePlacesDetails destination, bool mapLoaded)
          {
            Marker placeToMarker(dynamic place, String name) {
              return new Marker(
                markerId: MarkerId("${name}_${DateTime.now().millisecondsSinceEpoch}"),
                position: LatLng(place.geometry.location.lat, place.geometry.location.lng),
                infoWindow: InfoWindow(
                  title: name,
                  snippet: place.name,
                ),
              );
            }

            if(origin == null || destination == null) {
              if(origin != null)
                return [placeToMarker(origin, "Origen")];
              else if(destination != null)
                return [placeToMarker(destination, "Destino")];
              else
                return [];
            }

            return [
              placeToMarker(origin, "Origen"),
              placeToMarker(destination, "Destino"),
            ];
          });

  Stream<bool> get originAndDestinationFilled => Rx.combineLatest2(originPlacesDetails, destinationPlacesDetails,
          (a, b) => a != null && b != null);
  Stream<bool> get elevatorAndNumberOfFloorsFilled => Rx.combineLatest2(fitsInElevator, numberOfFloors,
    (fitsInElevator, numberOfFloors) => fitsInElevator == true || (numberOfFloors != null && numberOfFloors >= 0));
  Stream<bool> get formCompleted => Rx.combineLatest5(originAndDestinationFilled, elevatorAndNumberOfFloorsFilled, selectedVehicleType, numberOfHelpers, transportedObjectsDetails,
          (originAndDestinationFilled, elevatorAndNumberOfFloorsFilled, selectedVehicleType, numberOfHelpers, transportedObjectsDetails) =>
              originAndDestinationFilled
              && elevatorAndNumberOfFloorsFilled
              && selectedVehicleType != null
              && numberOfHelpers >= 0
              && transportedObjectsDetails != null && transportedObjectsDetails.trim() != '');

  Future<Travel> submit() {
    return apiService.createTravelRequest(
      TravelPricingRequest(
        vehicleTypeId: _selectedVehicleType.value.id,
        origin: _originPlacesDetails.value.geometry.location,
        destination: _destinationPlacesDetails.value.geometry.location,
        departureTime: DateTime.now(),
        driverHandlesLoading: _driverHandlesLoading.value,
        driverHandlesUnloading: _driverHandlesUnloading.value,
        fitsInElevator: _fitsInElevator.value,
        numberOfFloors: _numberOfFloors.value,
        requiredAssistants: _driverLoadingAndUnloadingIntStatus.value,
      )
    );
  }

  void dispose() {
    _transportedObjectsDetails.close();
    _originPlacesDetails.close();
    _destinationPlacesDetails.close();
    _selectedVehicleType.close();
    _numberOfHelpers.close();
    _numberOfFloors.close();
    _fitsInElevator.close();
    _driverHandlesLoading.close();
    _driverHandlesUnloading.close();
    _driverLoadingAndUnloadingIntStatus.close();
    _currentTravelEstimation.close();
    _mapLoaded.close();
  }
}