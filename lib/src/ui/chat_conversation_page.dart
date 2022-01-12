import 'package:fletes_31_app/src/blocs/chat_conversation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatConversationPage extends StatefulWidget {
  static const routeName = '/chats/:id/';

  final int id;

  const ChatConversationPage(this.id, {Key key}) : super(key: key);

  @override
  _ChatConversationPageState createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final ChatConversationBloc bloc = ChatConversationBloc();

  @override
  void initState() {
    bloc.fetchMessages(widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      //child: Chat
    );
  }
}