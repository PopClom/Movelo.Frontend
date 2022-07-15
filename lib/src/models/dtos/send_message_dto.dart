import 'package:json_annotation/json_annotation.dart';

part 'send_message_dto.g.dart';


@JsonSerializable()
class SendMessageDTO {
  String messageBody;

  SendMessageDTO({
    this.messageBody,
  });

  factory SendMessageDTO.fromJson(Map<String, dynamic> json) => _$SendMessageDTOFromJson(json);
  Map<String, dynamic> toJson() => _$SendMessageDTOToJson(this);
}