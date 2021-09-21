import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'travel_pricing_request_model.g.dart';


@JsonSerializable()
class TravelPricingRequest {
  int vehicleTypeId;
  Location origin;
  Location destination;
  DateTime departureTime;
  bool driverHandlesLoading;
  bool driverHandlesUnloading;
  bool fitsInElevator;
  int numberOfFloors;
  int requiredAssistants;

  TravelPricingRequest({
    this.vehicleTypeId,
    this.origin,
    this.destination,
    this.departureTime,
    this.driverHandlesLoading,
    this.driverHandlesUnloading,
    this.fitsInElevator,
    this.numberOfFloors,
    this.requiredAssistants,
  });

  factory TravelPricingRequest.fromJson(Map<String, dynamic> json) => _$TravelPricingRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TravelPricingRequestToJson(this);
}