import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';

class NewTravelArgs {
  GooglePlacesDetails originPlacesDetails;
  GooglePlacesDetails destinationPlacesDetails;
  VehicleType selectedVehicleType;

  NewTravelArgs(this.originPlacesDetails, this.destinationPlacesDetails, this.selectedVehicleType);
}
