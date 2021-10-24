// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Route _$RouteFromJson(Map<String, dynamic> json) {
  return Route(
    distanceInMeters: json['distanceInMeters'] as int,
    travelTimeInSeconds: json['travelTimeInSeconds'] as int,
  );
}

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'distanceInMeters': instance.distanceInMeters,
      'travelTimeInSeconds': instance.travelTimeInSeconds,
    };
