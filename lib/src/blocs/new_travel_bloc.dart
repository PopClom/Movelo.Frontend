import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/dtos/travel_create_dto.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/models/dtos/travel_pricing_request_dto.dart';
import 'package:fletes_31_app/src/models/dtos/travel_pricing_result_dto.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:fletes_31_app/src/network/travel_api.dart';
import 'package:fletes_31_app/src/ui/travel_detail_page.dart';
import 'package:fletes_31_app/src/utils/helpers.dart';
import 'package:fletes_31_app/src/utils/flushbar.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';
import 'package:fletes_31_app/src/utils/whatsapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';

class NewTravelBloc {
  final apiService = TravelAPI(Dio());

  final BehaviorSubject<GooglePlacesDetails> _originPlacesDetails = BehaviorSubject<GooglePlacesDetails>();
  final BehaviorSubject<GooglePlacesDetails> _destinationPlacesDetails = BehaviorSubject<GooglePlacesDetails>();
  final BehaviorSubject<VehicleType> _selectedVehicleType = BehaviorSubject<VehicleType>();
  final BehaviorSubject<String> _transportedObjectsDetails = BehaviorSubject<String>();
  final BehaviorSubject<int> _numberOfHelpers = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<bool> _fitsInElevator = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<int> _numberOfFloors = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<bool> _driverHandlesLoading = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _driverHandlesUnloading = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<int> _driverLoadingAndUnloadingIntStatus = BehaviorSubject<int>.seeded(4);
  final BehaviorSubject<TravelPricingResult> _currentTravelEstimation = BehaviorSubject<TravelPricingResult>();
  final BehaviorSubject<bool> _isSubmitting = BehaviorSubject<bool>.seeded(false);
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
  Function(TravelPricingResult) get changeCurrentTravelEstimation => _currentTravelEstimation.sink.add;
  Function(bool) get changeIsSubmitting => _isSubmitting.sink.add;
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
  Stream<TravelPricingResult> get currentTravelEstimation => _currentTravelEstimation.stream;
  Stream<bool> get isSubmitting => _isSubmitting.stream;
  Stream<bool> get mapLoaded => _mapLoaded.stream;

  Stream<List<Marker>> get originAndDestinationMarkers => Rx.combineLatest3(
      originPlacesDetails, destinationPlacesDetails, mapLoaded, (
      GooglePlacesDetails origin, GooglePlacesDetails destination, bool mapLoaded) {
        if(origin == null || destination == null) {
          if(origin != null)
            return [_placeToMarker(origin, "Origen")];
          else if(destination != null)
            return [_placeToMarker(destination, "Destino")];
          else
            return [];
        }

        return [
          _placeToMarker(origin, "Origen"),
          _placeToMarker(destination, "Destino"),
        ];
      }
  );

  Stream<bool> get transportedObjectsDetailsFilled => transportedObjectsDetails.map(
          (details) => details != null && details.trim() != '');

  Stream<bool> get originAndDestinationFilled => Rx.combineLatest2(originPlacesDetails, destinationPlacesDetails,
          (a, b) => a != null && b != null);

  Stream<bool> get elevatorAndNumberOfFloorsFilled => Rx.combineLatest2(fitsInElevator, numberOfFloors,
    (fitsInElevator, numberOfFloors) => fitsInElevator == true || (numberOfFloors != null && numberOfFloors >= 0));

  Stream<bool> get formCompleted => Rx.combineLatest6(
      originAndDestinationFilled, elevatorAndNumberOfFloorsFilled, selectedVehicleType,
      numberOfHelpers, transportedObjectsDetailsFilled.distinct(), driverLoadingAndUnloadingIntStatus,
          (originAndDestinationFilled, elevatorAndNumberOfFloorsFilled, selectedVehicleType,
          numberOfHelpers, transportedObjectsDetailsFilled, driverLoadingAndUnloadingFilled) =>
              originAndDestinationFilled
              && elevatorAndNumberOfFloorsFilled
              && selectedVehicleType != null
              && numberOfHelpers != null && numberOfHelpers >= 0
              && transportedObjectsDetailsFilled
              && driverLoadingAndUnloadingFilled != null);

  Future<TravelPricingResult> submit() async {
    GooglePlacesDetails origin = _originPlacesDetails.value;
    GooglePlacesDetails destination = _destinationPlacesDetails.value;

    return apiService.createTravelRequest(
      TravelPricingRequest(
        vehicleTypeId: _selectedVehicleType.value.id,
        origin: new Location(
          name: origin.formattedAddress,
          lat: origin.geometry.location.lat,
          lng: origin.geometry.location.lng,
        ),
        destination: new Location(
          name: destination.formattedAddress,
          lat: destination.geometry.location.lat,
          lng: destination.geometry.location.lng,
        ),
        departureTime: DateTime.now(),
        driverHandlesLoading: _driverHandlesLoading.value,
        driverHandlesUnloading: _driverHandlesUnloading.value,
        fitsInElevator: _fitsInElevator.value,
        numberOfFloors: _numberOfFloors.value,
        requiredAssistants: _numberOfHelpers.value,
      )
    );
  }

  Future<void> confirmTravelRequest() async {
    /*String message = "¡Hola! Quisiera pedir un/a *VEHICLE_TYPE* para transportar *TRANSPORTED_OBJECT_DESCRIPTION* desde *ORIGIN_ADDRESS* hasta *DESTINATION_ADDRESS*."
        .replaceFirst("VEHICLE_TYPE", _selectedVehicleType.value.name)
        .replaceFirst("TRANSPORTED_OBJECT_DESCRIPTION", _transportedObjectsDetails.value)
        .replaceFirst("ORIGIN_ADDRESS", _originPlacesDetails.value.formattedAddress)
        .replaceFirst("DESTINATION_ADDRESS", _destinationPlacesDetails.value.formattedAddress);

    if(_driverHandlesLoading.value || _driverHandlesUnloading.value) {
      if(!_driverHandlesLoading.value) {
        message += "\nRequiero que se encarguen de descargar los artículos transportados en destino.";
      } else if (!_driverHandlesUnloading.value) {
        message += "\nRequiero que se encarguen de cargar los artículos transportados en el origen.";
      } else {
        message += "\nRequiero que se encarguen tanto de la carga como de la descarga de los artículos transportados.";
      }
    } else {
      message += "\nNo requiero que se hagan cargo ni de la carga ni de la descarga de los artículos transportados.";
    }

    if(_numberOfFloors.value == 1) {
      message += "\nLa carga debe trasladarse *1 piso por ${_fitsInElevator.value ? "ascensor" : "escalera"}*.";
    } else if(_numberOfFloors.value > 1) {
      message += "\nLa carga debe trasladarse *${_numberOfFloors.value} pisos por ${_fitsInElevator.value ? "ascensor" : "escalera"}*.";
    }

    if(_numberOfHelpers.value == 1) {
      message += "\nPara esto solicito también la presencia de *1 ayudante* adicional.";
    } else if(_numberOfHelpers.value > 1) {
      message += "\nPara esto solicito también la presencia de *${_numberOfHelpers.value} ayudantes* adicionales.";
    }

    message += "\n¡Muchas gracias!";

    return await sendWhatsAppMessage("5491158424244", message);*/

    try {
      changeIsSubmitting(true);
      Travel travel = await apiService.confirmTravelRequest(
        TravelCreate(
          travelPricingToken: _currentTravelEstimation.value.travelPricingToken,
          transportedObjectDescription: _transportedObjectsDetails.value,
        )
      );
      Navigator.pushReplacementNamed(
        Navigation.navigationKey.currentContext,
        TravelDetailPage.routeName.replaceAll(':id', travel.id.toString()),
      );
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudo realizar el pedido'
        );
      }
    } finally {
      changeIsSubmitting(false);
    }
  }

  Marker _placeToMarker(dynamic place, String name) {
    return new Marker(
      markerId: MarkerId("${name}_${DateTime.now().millisecondsSinceEpoch}"),
      position: LatLng(place.geometry.location.lat, place.geometry.location.lng),
      infoWindow: InfoWindow(
        title: name,
        snippet: place.name,
      ),
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
    _isSubmitting.close();
    _mapLoaded.close();
  }
}