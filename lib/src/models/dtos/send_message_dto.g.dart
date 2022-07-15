// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMessageDTO _$SendMessageDTOFromJson(Map<String, dynamic> json) {
  return SendMessageDTO(
    messageBody: json['messageBody'] as String,
  );
}

Map<String, dynamic> _$SendMessageDTOToJson(SendMessageDTO instance) =>
    <String, dynamic>{
      'messageBody': instance.messageBody,
    };
