import 'package:json_annotation/json_annotation.dart';
import 'package:fletes_31_app/src/models/user_model.dart';

part 'profile_device_data_model.g.dart';


@JsonSerializable()
class ProfileDeviceData {
  int id;
  int profileId;
  User profile;
  String platform;
  String platformVersion;
  String notificationToken;
  DateTime registeredTime;

  ProfileDeviceData({
    this.id,
    this.profileId,
    this.profile,
    this.platform,
    this.platformVersion,
    this.notificationToken,
    this.registeredTime,
  });

  factory ProfileDeviceData.fromJson(Map<String, dynamic> json) => _$ProfileDeviceDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileDeviceDataToJson(this);
}