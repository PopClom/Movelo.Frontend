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
    status: _$enumDecodeNullable(_$TravelStatusEnumMap, json['status']),
    driverId: json['driverId'] as int,
    price: (json['price'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$TravelToJson(Travel instance) => <String, dynamic>{
      'id': instance.id,
      'requestingUserId': instance.requestingUserId,
      'requestedVehicleTypeId': instance.requestedVehicleTypeId,
      'status': _$TravelStatusEnumMap[instance.status],
      'driverId': instance.driverId,
      'price': instance.price,
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
