// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ChatAPI implements ChatAPI {
  _ChatAPI(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://localhost:44312/api/chats/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<PagedList<ChatConversation>> queryConversations() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PagedList<ChatConversation>.fromJson(
      _result.data,
      (json) => ChatConversation.fromJson(json),
    );
    return value;
  }

  @override
  Future<PagedList<ChatMessage>> queryConversationMessagesAsync(
      conversationId) async {
    ArgumentError.checkNotNull(conversationId, 'conversationId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('$conversationId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PagedList<ChatMessage>.fromJson(
      _result.data,
      (json) => ChatMessage.fromJson(json),
    );
    return value;
  }
}
