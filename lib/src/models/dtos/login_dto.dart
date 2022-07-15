import 'package:fletes_31_app/src/models/dtos/device_register_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

enum LoginSchema {
  Password,
  Facebook,
  Google
}

@JsonSerializable()
class Login {
  LoginSchema schema;
  String usernameOrToken;
  String password;
  DeviceRegister deviceData;

  Login({
    this.schema,
    this.usernameOrToken,
    this.password,
    this.deviceData,
  });

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);
  Map<String, dynamic> toJson() => _$LoginToJson(this);
}