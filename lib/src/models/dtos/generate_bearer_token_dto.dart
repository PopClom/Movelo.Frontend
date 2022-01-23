import 'package:json_annotation/json_annotation.dart';

part 'generate_bearer_token_dto.g.dart';

@JsonSerializable()
class GenerateBearerToken {
  String refreshToken;

  GenerateBearerToken({
    this.refreshToken,
  });

  factory GenerateBearerToken.fromJson(Map<String, dynamic> json) => _$GenerateBearerTokenFromJson(json);
  Map<String, dynamic> toJson() => _$GenerateBearerTokenToJson(this);
}