// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatConversation _$ChatConversationFromJson(Map<String, dynamic> json) {
  return ChatConversation(
    json['id'] as int,
    (json['participants'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['messages'] as List)
        ?.map((e) =>
            e == null ? null : ChatMessage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['title'] as String,
    json['active'] as bool,
  );
}

Map<String, dynamic> _$ChatConversationToJson(ChatConversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participants': instance.participants,
      'messages': instance.messages,
      'title': instance.title,
      'active': instance.active,
    };
