// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_create_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TravelCreate _$TravelCreateFromJson(Map<String, dynamic> json) {
  return TravelCreate(
    travelPricingToken: json['travelPricingToken'] as String,
    transportedObjectDescription:
        json['transportedObjectDescription'] as String,
  );
}

Map<String, dynamic> _$TravelCreateToJson(TravelCreate instance) =>
    <String, dynamic>{
      'travelPricingToken': instance.travelPricingToken,
      'transportedObjectDescription': instance.transportedObjectDescription,
    };
