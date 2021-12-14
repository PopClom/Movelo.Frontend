import 'package:json_annotation/json_annotation.dart';

part 'travel_create_dto.g.dart';


@JsonSerializable()
class TravelCreate {
  String travelPricingToken;
  String transportedObjectDescription;

  TravelCreate({
    this.travelPricingToken,
    this.transportedObjectDescription,
  });

  factory TravelCreate.fromJson(Map<String, dynamic> json) => _$TravelCreateFromJson(json);
  Map<String, dynamic> toJson() => _$TravelCreateToJson(this);
}