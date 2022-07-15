import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/chat_conversation_model.dart';
import 'package:fletes_31_app/src/models/paged_list_model.dart';
import 'package:fletes_31_app/src/network/chat_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fletes_31_app/src/network/travel_api.dart';
import 'package:fletes_31_app/src/utils/flushbar.dart';
import 'package:fletes_31_app/src/utils/helpers.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';

class ChatListBloc {
  final chatApi = ChatAPI(Dio());
  final travelApi = TravelAPI(Dio());

  final BehaviorSubject<List<ChatConversation>> _conversations = BehaviorSubject<List<ChatConversation>>();

  BehaviorSubject<List<ChatConversation>> get conversations => _conversations;

  Future<void> fetchConversations() async {
    try {
      PagedList<ChatConversation> conversationsPagedList = await chatApi.queryConversations();
      _conversations.sink.add(conversationsPagedList.data);
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudieron cargar tus conversaciones.'
        );
      }
    }
  }

  dispose() {
    _conversations.close();
  }
}