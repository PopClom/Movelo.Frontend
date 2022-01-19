// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_device_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDeviceData _$ProfileDeviceDataFromJson(Map<String, dynamic> json) {
  return ProfileDeviceData(
    id: json['id'] as int,
    profileId: json['profileId'] as int,
    profile: json['profile'] == null
        ? null
        : User.fromJson(json['profile'] as Map<String, dynamic>),
    platform: json['platform'] as String,
    platformVersion: json['platformVersion'] as String,
    notificationToken: json['notificationToken'] as String,
    registeredTime: json['registeredTime'] == null
        ? null
        : DateTime.parse(json['registeredTime'] as String),
  );
}

Map<String, dynamic> _$ProfileDeviceDataToJson(ProfileDeviceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileId': instance.profileId,
      'profile': instance.profile,
      'platform': instance.platform,
      'platformVersion': instance.platformVersion,
      'notificationToken': instance.notificationToken,
      'registeredTime': instance.registeredTime?.toIso8601String(),
    };
