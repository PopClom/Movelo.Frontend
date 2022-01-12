// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return ChatMessage(
    json['id'] as int,
    json['conversationId'] as int,
    json['conversation'] == null
        ? null
        : ChatConversation.fromJson(
            json['conversation'] as Map<String, dynamic>),
    json['senderId'] as int,
    json['sender'] == null
        ? null
        : User.fromJson(json['sender'] as Map<String, dynamic>),
    json['sendTime'] == null
        ? null
        : DateTime.parse(json['sendTime'] as String),
    json['body'] as String,
  );
}

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'conversation': instance.conversation,
      'senderId': instance.senderId,
      'sender': instance.sender,
      'sendTime': instance.sendTime?.toIso8601String(),
      'body': instance.body,
    };
