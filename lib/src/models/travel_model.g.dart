// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Travel _$TravelFromJson(Map<String, dynamic> json) {
  return Travel(
    id: json['id'] as int,
    requestingUserId: json['requestingUserId'] as int,
    requestedVehicleTypeId: json['requestedVehicleTypeId'] as int,
    driverId: json['driverId'] as int,
    estimatedPrice: (json['estimatedPrice'] as num)?.toDouble(),
  )..estimatedRoute = json['estimatedRoute'] == null
      ? null
      : Route.fromJson(json['estimatedRoute'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TravelToJson(Travel instance) => <String, dynamic>{
      'id': instance.id,
      'requestingUserId': instance.requestingUserId,
      'requestedVehicleTypeId': instance.requestedVehicleTypeId,
      'driverId': instance.driverId,
      'estimatedPrice': instance.estimatedPrice,
      'estimatedRoute': instance.estimatedRoute,
    };
