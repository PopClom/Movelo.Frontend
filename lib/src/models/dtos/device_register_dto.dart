import 'package:json_annotation/json_annotation.dart';

part 'device_register_dto.g.dart';


@JsonSerializable()
class DeviceRegister {
  String notificationToken;
  String platform;
  String platformVersion;

  DeviceRegister({
    this.notificationToken,
    this.platform,
    this.platformVersion,
  });

  factory DeviceRegister.fromJson(Map<String, dynamic> json) => _$DeviceRegisterFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceRegisterToJson(this);
}