// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_pricing_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TravelPricingResult _$TravelPricingResultFromJson(Map<String, dynamic> json) {
  return TravelPricingResult(
    travel: json['travel'] == null
        ? null
        : Travel.fromJson(json['travel'] as Map<String, dynamic>),
    travelPricingToken: json['travelPricingToken'] as String,
  );
}

Map<String, dynamic> _$TravelPricingResultToJson(
        TravelPricingResult instance) =>
    <String, dynamic>{
      'travel': instance.travel,
      'travelPricingToken': instance.travelPricingToken,
    };
