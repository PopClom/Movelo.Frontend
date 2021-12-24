// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) {
  return Vehicle(
    id: json['id'] as int,
    vehicleTypeId: json['vehicleTypeId'] as int,
    type: json['type'] == null
        ? null
        : VehicleType.fromJson(json['type'] as Map<String, dynamic>),
    ownerId: json['ownerId'] as int,
    brand: json['brand'] as String,
    model: json['model'] as String,
    licensePlate: json['licensePlate'] as String,
    currentlyActive: json['currentlyActive'] as bool,
  );
}

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id': instance.id,
      'vehicleTypeId': instance.vehicleTypeId,
      'type': instance.type,
      'ownerId': instance.ownerId,
      'brand': instance.brand,
      'model': instance.model,
      'licensePlate': instance.licensePlate,
      'currentlyActive': instance.currentlyActive,
    };
