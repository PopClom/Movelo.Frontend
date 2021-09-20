import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:rxdart/rxdart.dart';

class NewTravelFragmentBloc {
  final BehaviorSubject<GooglePlacesDetails> _originPlacesDetails = BehaviorSubject<GooglePlacesDetails>();
  final BehaviorSubject<GooglePlacesDetails> _destinationPlacesDetails = BehaviorSubject<GooglePlacesDetails>();
  final BehaviorSubject<VehicleType> _selectedVehicleType = BehaviorSubject<VehicleType>();
  final BehaviorSubject<bool> _requiresLoading = BehaviorSubject<bool>.seeded(false);
  
  Function(GooglePlacesDetails) get changeOriginPlacesDetails => _originPlacesDetails.sink.add;
  Function(GooglePlacesDetails) get changeDestinationPlacesDetails => _destinationPlacesDetails.sink.add;
  Function(VehicleType) get changeSelectedVehicleType => _selectedVehicleType.sink.add;
  Function(bool) get changeRequiresLoading => _requiresLoading.sink.add;

  Stream<GooglePlacesDetails> get originPlacesDetails => _originPlacesDetails.stream;
  Stream<GooglePlacesDetails> get destinationPlacesDetails => _destinationPlacesDetails.stream;
  Stream<VehicleType> get selectedVehicleType => _selectedVehicleType.stream;
  Stream<bool> get requiresLoading => _requiresLoading.stream;

  Stream<bool> get originAndDestinationFilled => Rx.combineLatest2(originPlacesDetails, destinationPlacesDetails,
          (a, b) => a != null && b != null);
  Stream<bool> get formCompleted => Rx.combineLatest3(originAndDestinationFilled, requiresLoading, selectedVehicleType,
          (a, b, c) => a && b != null && c != null);

  void dispose() {
    _originPlacesDetails.close();
    _destinationPlacesDetails.close();
    _selectedVehicleType.close();
    _requiresLoading.close();
  }
}