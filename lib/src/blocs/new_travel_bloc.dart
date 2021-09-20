import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:rxdart/rxdart.dart';

class NewTravelBloc {
  final BehaviorSubject<GooglePlacesDetails> _originPlacesDetails = BehaviorSubject<GooglePlacesDetails>();
  final BehaviorSubject<GooglePlacesDetails> _destinationPlacesDetails = BehaviorSubject<GooglePlacesDetails>();
  final BehaviorSubject<VehicleType> _selectedVehicleType = BehaviorSubject<VehicleType>();
  final BehaviorSubject<String> _transportedObjectsDetails = BehaviorSubject<String>();
  final BehaviorSubject<int> _numberOfHelpers = BehaviorSubject<int>();
  final BehaviorSubject<bool> _fitsInElevator = BehaviorSubject<bool>();
  final BehaviorSubject<int> _numberOfFloors = BehaviorSubject<int>();
  
  Function(GooglePlacesDetails) get changeOriginPlacesDetails => _originPlacesDetails.sink.add;
  Function(GooglePlacesDetails) get changeDestinationPlacesDetails => _destinationPlacesDetails.sink.add;
  Function(VehicleType) get changeSelectedVehicleType => _selectedVehicleType.sink.add;
  Function(String) get changeTransportedObjectsDetails => _transportedObjectsDetails.sink.add;
  Function(int) get changeNumberOfHelpers => _numberOfHelpers.sink.add;
  Function(bool) get changeFitsInElevator => _fitsInElevator.sink.add;
  Function(int) get changeNumberOfFloors => _numberOfFloors.sink.add;
  //Function(bool) get changeRequiresLoading => _requiresLoading.sink.add;

  Stream<GooglePlacesDetails> get originPlacesDetails => _originPlacesDetails.stream;
  Stream<GooglePlacesDetails> get destinationPlacesDetails => _destinationPlacesDetails.stream;
  Stream<VehicleType> get selectedVehicleType => _selectedVehicleType.stream;
  Stream<String> get transportedObjectsDetails => _transportedObjectsDetails.stream;
  Stream<int> get numberOfHelpers => _numberOfHelpers.stream;
  Stream<bool> get fitsInElevator => _fitsInElevator.stream;
  Stream<int> get numberOfFloors => _numberOfFloors.stream;
  //Stream<bool> get requiresLoading => _requiresLoading.stream;

  Stream<bool> get originAndDestinationFilled => Rx.combineLatest2(originPlacesDetails, destinationPlacesDetails,
          (a, b) => a != null && b != null);
  Stream<bool> get elevatorAndNumberOfFloorsFilled => Rx.combineLatest2(fitsInElevator, numberOfFloors,
  (a, b) => a == false || (b != null && b >= 0));
  Stream<bool> get formCompleted => Rx.combineLatest5(originAndDestinationFilled, elevatorAndNumberOfFloorsFilled, selectedVehicleType, numberOfHelpers, transportedObjectsDetails,
          (a, b, c, d, e) => a && b != null && c != null && d != null && d >= 0 && e != null);

  void dispose() {
    _originPlacesDetails.close();
    _destinationPlacesDetails.close();
    _selectedVehicleType.close();
    _numberOfFloors.close();
    _fitsInElevator.close();
    _transportedObjectsDetails.close();
    //_requiresLoading.close();
  }
}