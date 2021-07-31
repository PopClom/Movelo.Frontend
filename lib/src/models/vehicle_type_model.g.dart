// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleType _$VehicleTypeFromJson(Map<String, dynamic> json) {
  return VehicleType(
    id: json['id'] as int,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String,
    maxWeightInKilograms: (json['maxWeightInKilograms'] as num)?.toDouble(),
    widthInMeters: (json['widthInMeters'] as num)?.toDouble(),
    heightInMeters: (json['heightInMeters'] as num)?.toDouble(),
    depthInMeters: (json['depthInMeters'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$VehicleTypeToJson(VehicleType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'maxWeightInKilograms': instance.maxWeightInKilograms,
      'widthInMeters': instance.widthInMeters,
      'heightInMeters': instance.heightInMeters,
      'depthInMeters': instance.depthInMeters,
    };
