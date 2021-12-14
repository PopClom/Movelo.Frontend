import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'travel_pricing_result_dto.g.dart';


@JsonSerializable()
class TravelPricingResult {
  Travel travel;
  String travelPricingToken;

  TravelPricingResult({
    this.travel,
    this.travelPricingToken,
  });

  factory TravelPricingResult.fromJson(Map<String, dynamic> json) => _$TravelPricingResultFromJson(json);
  Map<String, dynamic> toJson() => _$TravelPricingResultToJson(this);
}