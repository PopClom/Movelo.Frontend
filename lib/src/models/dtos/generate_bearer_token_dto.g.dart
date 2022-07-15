// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_bearer_token_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateBearerToken _$GenerateBearerTokenFromJson(Map<String, dynamic> json) {
  return GenerateBearerToken(
    refreshToken: json['refreshToken'] as String,
  );
}

Map<String, dynamic> _$GenerateBearerTokenToJson(
        GenerateBearerToken instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
    };
