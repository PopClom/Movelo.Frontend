import 'package:fletes_31_app/src/models/chat_conversation_model.dart';
import 'package:fletes_31_app/src/models/chat_message_model.dart';
import 'package:fletes_31_app/src/models/paged_list_model.dart';
import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/utils/constants.dart' as Constants;

import 'authentication_interceptor.dart';

part 'chat_api.g.dart';

@RestApi(baseUrl: Constants.BASE_URL + 'chats/')
abstract class ChatAPI {
  factory ChatAPI(Dio dio, {String baseUrl}) {
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(AuthenticationInterceptor());
    return _ChatAPI(dio, baseUrl: baseUrl);
  }

  @GET('')
  Future<PagedList<ChatConversation>> queryConversations();

  @GET('{conversationId}')
  Future<PagedList<ChatMessage>> queryConversationMessagesAsync(@Path('conversationId') int conversationId);
}