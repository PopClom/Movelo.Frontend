import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'authentication_result_dto.g.dart';

@JsonSerializable()
class AuthenticationResult {
  User profile;
  int uniqueDeviceId;
  String refreshToken;
  String bearerToken;

  AuthenticationResult({
    this.profile,
    this.uniqueDeviceId,
    this.refreshToken,
    this.bearerToken,
  });

  factory AuthenticationResult.fromJson(Map<String, dynamic> json) => _$AuthenticationResultFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationResultToJson(this);
}