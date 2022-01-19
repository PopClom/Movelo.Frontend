import 'package:fletes_31_app/src/blocs/auth_bloc.dart';
import 'package:fletes_31_app/src/blocs/chat_conversation_bloc.dart';
import 'package:fletes_31_app/src/models/chat_conversation_model.dart';
import 'package:fletes_31_app/src/models/chat_message_model.dart';
import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:flutter/material.dart';

class ChatConversationPage extends StatefulWidget {
  static const routeName = '/chats/:id/';

  final int id;

  const ChatConversationPage(this.id, {Key key}) : super(key: key);

  @override
  _ChatConversationPageState createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final ChatConversationBloc bloc = ChatConversationBloc();
  final TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    bloc.fetchConversation(widget.id);
    bloc.fetchMessages(widget.id);

    //bloc.initializeSignalRHub(widget.id);
    bloc.startMessagePolling(widget.id);

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: StreamBuilder<ChatConversation>(
                  stream: bloc.conversation,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      String imageUrl;

                      List<User> otherParticipants = new List<User>.from(snap.data.participants);
                      otherParticipants.removeWhere((user) => user.id == authBloc.getUserId());

                      return Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back,color: Colors.black,),
                          ),
                          SizedBox(width: 2,),
                          CircleAvatar(
                            backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                            child: imageUrl == null ? Text(otherParticipants[0].firstName.substring(0, 1) + otherParticipants[0].lastName.substring(0, 1)) : null,
                            maxRadius: 20,
                          ),
                          SizedBox(width: 12,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('${otherParticipants[0].firstName} ${otherParticipants[0].lastName}', style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                                SizedBox(height: 6,),
                                Text('En linea', style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                              ],
                            ),
                          ),
                          Icon(Icons.settings,color: Colors.black54),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
              ),
            ),
          ),
        ),
      body: Stack(
        children: <Widget>[
        StreamBuilder<List<ChatMessage>>(
          stream: bloc.messages,
          builder: (context, snap) {
            if (snap.hasData) {
              if (snap.data.isEmpty) {
                return Container(
                  child: Center(
                    child: Text(
                      'Aun no hay mensajes.\n¡Enviá uno!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  )
                );
              } else {
                return ListView.builder(
                  itemCount: snap.data.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10,bottom: 10),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    ChatMessage message = snap.data[index];
                    bool isSender = message.senderId == authBloc.getUserId();

                    return Container(
                      padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                      child: Align(
                        alignment: (!isSender ? Alignment.topLeft : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (!isSender ? Colors.grey.shade200:Colors.blue[200]),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(message.body, style: TextStyle(fontSize: 15),),
                        ),
                      ),
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
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  /*GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),*/
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Escribí un mensaje...',
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ),
                      controller: controller,
                      onChanged: bloc.changeNewMessageText,
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: () {
                      bloc.sendMessage(widget.id);
                      controller.text = '';
                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],

              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}