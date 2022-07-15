// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationResult _$AuthenticationResultFromJson(Map<String, dynamic> json) {
  return AuthenticationResult(
    profile: json['profile'] == null
        ? null
        : User.fromJson(json['profile'] as Map<String, dynamic>),
    uniqueDeviceId: json['uniqueDeviceId'] as int,
    refreshToken: json['refreshToken'] as String,
    bearerToken: json['bearerToken'] as String,
  );
}

Map<String, dynamic> _$AuthenticationResultToJson(
        AuthenticationResult instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'uniqueDeviceId': instance.uniqueDeviceId,
      'refreshToken': instance.refreshToken,
      'bearerToken': instance.bearerToken,
    };
