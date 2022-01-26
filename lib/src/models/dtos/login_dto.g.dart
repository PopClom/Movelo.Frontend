// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Login _$LoginFromJson(Map<String, dynamic> json) {
  return Login(
    schema: _$enumDecodeNullable(_$LoginSchemaEnumMap, json['schema']),
    usernameOrToken: json['usernameOrToken'] as String,
    password: json['password'] as String,
    deviceData: json['deviceData'] == null
        ? null
        : DeviceRegister.fromJson(json['deviceData'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LoginToJson(Login instance) => <String, dynamic>{
      'schema': _$LoginSchemaEnumMap[instance.schema],
      'usernameOrToken': instance.usernameOrToken,
      'password': instance.password,
      'deviceData': instance.deviceData,
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

const _$LoginSchemaEnumMap = {
  LoginSchema.Password: 'Password',
  LoginSchema.Facebook: 'Facebook',
  LoginSchema.Google: 'Google',
};
