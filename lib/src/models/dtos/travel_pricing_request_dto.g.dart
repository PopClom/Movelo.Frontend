// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_pricing_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TravelPricingRequest _$TravelPricingRequestFromJson(Map<String, dynamic> json) {
  return TravelPricingRequest(
    vehicleTypeId: json['vehicleTypeId'] as int,
    origin: json['origin'] == null
        ? null
        : Location.fromJson(json['origin'] as Map<String, dynamic>),
    destination: json['destination'] == null
        ? null
        : Location.fromJson(json['destination'] as Map<String, dynamic>),
    departureDateTime: json['departureDateTime'] == null
        ? null
        : DateTime.parse(json['departureDateTime'] as String),
    driverHandlesLoading: json['driverHandlesLoading'] as bool,
    driverHandlesUnloading: json['driverHandlesUnloading'] as bool,
    fitsInElevator: json['fitsInElevator'] as bool,
    numberOfFloors: json['numberOfFloors'] as int,
    requiredAssistants: json['requiredAssistants'] as int,
  );
}

Map<String, dynamic> _$TravelPricingRequestToJson(
        TravelPricingRequest instance) =>
    <String, dynamic>{
      'vehicleTypeId': instance.vehicleTypeId,
      'origin': instance.origin,
      'destination': instance.destination,
      'departureDateTime': instance.departureDateTime?.toIso8601String(),
      'driverHandlesLoading': instance.driverHandlesLoading,
      'driverHandlesUnloading': instance.driverHandlesUnloading,
      'fitsInElevator': instance.fitsInElevator,
      'numberOfFloors': instance.numberOfFloors,
      'requiredAssistants': instance.requiredAssistants,
    };
