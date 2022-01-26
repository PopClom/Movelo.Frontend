// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_register_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceRegister _$DeviceRegisterFromJson(Map<String, dynamic> json) {
  return DeviceRegister(
    notificationToken: json['notificationToken'] as String,
    platform: json['platform'] as String,
    platformVersion: json['platformVersion'] as String,
  );
}

Map<String, dynamic> _$DeviceRegisterToJson(DeviceRegister instance) =>
    <String, dynamic>{
      'notificationToken': instance.notificationToken,
      'platform': instance.platform,
      'platformVersion': instance.platformVersion,
    };
