import 'package:fletes_31_app/src/models/chat_message_model.dart';
import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_conversation_model.g.dart';

@JsonSerializable()
class ChatConversation {
  int id;
  List<User> participants;
  List<ChatMessage> messages;
  String title;
  bool active;

  ChatConversation(this.id, this.participants, this.messages, this.title, this.active);

  factory ChatConversation.fromJson(Map<String, dynamic> json) => _$ChatConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ChatConversationToJson(this);
}
