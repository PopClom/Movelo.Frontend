import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'chat_conversation_model.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessage {
  int id;
  int conversationId;
  ChatConversation conversation;
  int senderId;
  User sender;
  DateTime sendTime;
  String body;

  ChatMessage(this.id, this.conversationId, this.conversation, this.senderId,
      this.sender, this.sendTime, this.body);

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
