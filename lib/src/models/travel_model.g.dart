// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Travel _$TravelFromJson(Map<String, dynamic> json) {
  return Travel(
    id: json['id'] as int,
    requestingUserId: json['requestingUserId'] as int,
    requestedVehicleType: json['requestedVehicleType'] == null
        ? null
        : VehicleType.fromJson(
            json['requestedVehicleType'] as Map<String, dynamic>),
    status: _$enumDecodeNullable(_$TravelStatusEnumMap, json['status']),
    driverId: json['driverId'] as int,
    driverHandlesLoading: json['driverHandlesLoading'] as bool,
    driverHandlesUnloading: json['driverHandlesUnloading'] as bool,
    fitsInElevator: json['fitsInElevator'] as bool,
    requiredAssistants: json['requiredAssistants'] as int,
    numberOfFloors: json['numberOfFloors'] as int,
    origin: json['origin'] == null
        ? null
        : Location.fromJson(json['origin'] as Map<String, dynamic>),
    destination: json['destination'] == null
        ? null
        : Location.fromJson(json['destination'] as Map<String, dynamic>),
    estimatedPrice: (json['estimatedPrice'] as num)?.toDouble(),
    estimatedRoute: json['estimatedRoute'] == null
        ? null
        : Route.fromJson(json['estimatedRoute'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TravelToJson(Travel instance) => <String, dynamic>{
      'id': instance.id,
      'requestingUserId': instance.requestingUserId,
      'requestedVehicleType': instance.requestedVehicleType,
      'status': _$TravelStatusEnumMap[instance.status],
      'driverId': instance.driverId,
      'driverHandlesLoading': instance.driverHandlesLoading,
      'driverHandlesUnloading': instance.driverHandlesUnloading,
      'fitsInElevator': instance.fitsInElevator,
      'requiredAssistants': instance.requiredAssistants,
      'numberOfFloors': instance.numberOfFloors,
      'origin': instance.origin,
      'destination': instance.destination,
      'estimatedPrice': instance.estimatedPrice,
      'estimatedRoute': instance.estimatedRoute,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$TravelStatusEnumMap = {
  TravelStatus.PendingUserConfirmation: 'PendingUserConfirmation',
  TravelStatus.PendingDriver: 'PendingDriver',
  TravelStatus.ConfirmedAndPendingStart: 'ConfirmedAndPendingStart',
  TravelStatus.InProcess: 'InProcess',
  TravelStatus.Completed: 'Completed',
};
