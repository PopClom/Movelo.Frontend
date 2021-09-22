import 'package:json_annotation/json_annotation.dart';

part 'route_model.g.dart';

@JsonSerializable()
class Route {
  int distanceInMeters;
  int travelTimeInSeconds;

  Route({this.distanceInMeters, this.travelTimeInSeconds});

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);
  Map<String, dynamic> toJson() => _$RouteToJson(this);
}