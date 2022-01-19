import 'package:fletes_31_app/src/blocs/auth_bloc.dart';
import 'package:fletes_31_app/src/models/chat_conversation_model.dart';
import 'package:fletes_31_app/src/models/chat_message_model.dart';
import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:fletes_31_app/src/ui/chat_conversation_page.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';
import 'package:flutter/material.dart';

class ConversationListItem extends StatefulWidget{
  final ChatConversation conversation;

  ConversationListItem({@required this.conversation});

  @override
  _ConversationListItemState createState() => _ConversationListItemState();
}

class _ConversationListItemState extends State<ConversationListItem> {
  @override
  Widget build(BuildContext context) {
    String imageUrl;

    List<User> otherParticipants = new List<User>.from(widget.conversation.participants);
    otherParticipants.removeWhere((user) => user.id == authBloc.getUserId());

    String subtitle = '';
    bool isMessageRead = true;
    ChatMessage lastMessage = ChatMessage(1, widget.conversation.id, widget.conversation, authBloc.getUserId(), null, DateTime.now(), 'Hola Jorge');

    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
          Navigation.navigationKey.currentContext,
          ChatConversationPage.routeName.replaceAll(':id', widget.conversation.id.toString()),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                    child: imageUrl == null ? Text(otherParticipants[0].firstName.substring(0, 1) + otherParticipants[0].lastName.substring(0, 1)) : null,
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${otherParticipants[0].firstName} ${otherParticipants[0].lastName}', style: TextStyle(fontSize: 16),),
                          SizedBox(height: 6,),
                          Text(lastMessage.body,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: isMessageRead ? FontWeight.bold:FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(lastMessage.sendTime.toString(),style: TextStyle(fontSize: 12,fontWeight: isMessageRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}