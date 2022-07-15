import 'package:fletes_31_app/src/models/chat_conversation_model.dart';
import 'package:fletes_31_app/src/models/chat_message_model.dart';
import 'package:fletes_31_app/src/models/dtos/send_message_dto.dart';
import 'package:fletes_31_app/src/models/paged_list_model.dart';
import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/utils/constants.dart' as Constants;

import 'authentication_interceptor.dart';

part 'chat_api.g.dart';

@RestApi(baseUrl: Constants.API_BASE_URL + 'chats/')
abstract class ChatAPI {
  factory ChatAPI(Dio dio, {String baseUrl}) {
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(AuthenticationInterceptor());
    return _ChatAPI(dio, baseUrl: baseUrl);
  }

  @GET('')
  Future<PagedList<ChatConversation>> queryConversations();

  @GET('{conversationId}')
  Future<ChatConversation> getConversationById(@Path('conversationId') int conversationId);

  @GET('{conversationId}/messages')
  Future<PagedList<ChatMessage>> queryConversationMessagesWithIdLowerLimit(@Path('conversationId') int conversationId, @Query('idLowerLimit') int idLowerLimit);

  @GET('{conversationId}/messages')
  Future<PagedList<ChatMessage>> queryConversationMessagesWithIdUpperLimit(@Path('conversationId') int conversationId, @Query('idUpperLimit') int idUpperLimit);

  @GET('{conversationId}/messages')
  Future<PagedList<ChatMessage>> queryConversationMessages(@Path('conversationId') int conversationId);

  @POST('{conversationId}/messages')
  Future<ChatMessage> postMessageAsync(@Path('conversationId') int conversationId, @Body() SendMessageDTO messageDTO);
}