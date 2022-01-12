import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/chat_message_model.dart';
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

  final BehaviorSubject<List<ChatMessage>> _messages = BehaviorSubject<List<ChatMessage>>();

  BehaviorSubject<List<ChatMessage>> get messages => _messages;

  Future<void> fetchMessages(int conversationId) async {
    try {
      PagedList<ChatMessage> conversationsPagedList = await chatApi.queryConversationMessagesAsync(conversationId);
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

  dispose() {
    _messages.close();
  }
}