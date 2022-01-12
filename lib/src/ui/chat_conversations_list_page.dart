import 'package:fletes_31_app/src/blocs/chat_list_bloc.dart';
import 'package:fletes_31_app/src/models/chat_conversation_model.dart';
import 'package:fletes_31_app/src/models/chat_message_model.dart';
import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:fletes_31_app/src/ui/components/conversation_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatConversationsListPage extends StatefulWidget {
  static const routeName = '/chats';

  const ChatConversationsListPage({Key key}) : super(key: key);

  @override
  _ChatConversationsListPageState createState() => _ChatConversationsListPageState();
}

class _ChatConversationsListPageState extends State<ChatConversationsListPage> {
  final ChatListBloc bloc = ChatListBloc();

  @override
  void initState() {
    bloc.fetchConversations();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChatConversation> conversations = <ChatConversation>[
      ChatConversation(
          1,
          <User>[
            User(
              email: "holanico11@gmail.com",
              firstName: "Nicolas",
              lastName: "Barrera",
              profileType: "CLIENT"
            )
          ],
          new List<ChatMessage>(),
          null,
          true
      )
    ];

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16,left: 16,right: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey.shade100
                    )
                ),
              ),
            ),
          ),
          Expanded(
              child: StreamBuilder<List<ChatConversation>>(
                  stream: bloc.conversations,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      if (snap.data.isEmpty) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 35.0),
                          child: Text(
                            'No conversaciones abiertas actualmente.\n¡Aca apareceran tus conversaciones con los conductores que hayan aceptado tus pedidos!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: conversations.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 16),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            return ConversationListItem(
                              conversation: conversations[index],
                            );
                          },
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
              ),
          )
        ],
      )
    );
  }
}