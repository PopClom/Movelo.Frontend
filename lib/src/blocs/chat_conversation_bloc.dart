import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/chat_conversation_model.dart';
import 'package:fletes_31_app/src/models/chat_message_model.dart';
import 'package:fletes_31_app/src/models/dtos/send_message_dto.dart';
import 'package:fletes_31_app/src/models/paged_list_model.dart';
import 'package:fletes_31_app/src/network/chat_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fletes_31_app/src/network/travel_api.dart';
import 'package:fletes_31_app/src/utils/flushbar.dart';
import 'package:fletes_31_app/src/utils/helpers.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';

class ChatConversationBloc {
  final chatApi = ChatAPI(Dio());
  final travelApi = TravelAPI(Dio());

  //final connection = HubConnectionBuilder().withUrl(Constants.HUBS_BASE_URL + 'chat/', options: HttpConnectionOptions()).build();

  Timer messagePollingTimer;
  int latestDownloadedMessageId = 0;

  final BehaviorSubject<ChatConversation> _conversation = BehaviorSubject<ChatConversation>();
  final BehaviorSubject<List<ChatMessage>> _messages = BehaviorSubject<List<ChatMessage>>();
  final BehaviorSubject<String> _newMessageText = BehaviorSubject<String>();

  BehaviorSubject<List<ChatMessage>> get messages => _messages;
  BehaviorSubject<ChatConversation> get conversation => _conversation;
  Stream<String> get newMessageText => _newMessageText.stream;
  Stream<bool> get newMessageTextEmpty => newMessageText.map(
          (details) => details != null && details.trim() != '');

  Function(String) get changeNewMessageText => _newMessageText.sink.add;

  Future<void> fetchMessages(int conversationId) async {
    try {
      PagedList<ChatMessage> conversationsPagedList = await chatApi.queryConversationMessagesWithLatestDownloadedIdAsync(conversationId, latestDownloadedMessageId);
      latestDownloadedMessageId = conversationsPagedList.data.length > 0 ? conversationsPagedList.data[conversationsPagedList.data.length - 1].id : 0;
      _messages.sink.add(conversationsPagedList.data);
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudieron cargar los mensajes de esta conversacion.'
        );
      }
    }
  }

  Future<void> startMessagePolling(int conversationId) async {
    messagePollingTimer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
      fetchMessages(conversationId);
    });
  }

  Future<void> fetchConversation(int conversationId) async {
    try {
      ChatConversation conversation = await chatApi.getConversationById(conversationId);
      _conversation.sink.add(conversation);
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudieron cargar los mensajes de esta conversacion.'
        );
      }
    }
  }

  /*Future<void> initializeSignalRHub(int conversationId) async {
    try {
      await connection.start();

      connection.on('ReceiveMessage', (message) {
        print(message.toString());
      });
    } catch(e) {
      print(e);
    }

  }*/

  Future<void> sendMessage(int conversationId) async {
    String messageBody = _newMessageText.value;
    if(messageBody == null || messageBody.length == 0)
      return;

    SendMessageDTO dto = SendMessageDTO(messageBody: messageBody);

    try {
      ChatMessage message = await chatApi.postMessageAsync(conversationId, dto);
      fetchMessages(conversationId);
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudo enviar el mensaje.'
        );
      }
    } finally {

    }
  }

  dispose() async {
    _conversation.close();
    _messages.close();

    //connection.stop();
    messagePollingTimer.cancel();
  }
}