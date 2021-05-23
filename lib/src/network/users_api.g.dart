// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _UsersAPI implements UsersAPI {
  _UsersAPI(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://localhost:44312/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<HttpResponse<User>> getCurrentUserWithResponse(authHeader) async {
    ArgumentError.checkNotNull(authHeader, 'authHeader');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('users/current',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': authHeader},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = User.fromJson(_result.data);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<User> getCurrentUser() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('users/current',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = User.fromJson(_result.data);
    return value;
  }

  @override
  Future<String> createUser(user) async {
    ArgumentError.checkNotNull(user, 'user');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(user?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<String>('users',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return value;
  }

  @override
  Future<List<User>> checkEmailAvailable(email) async {
    ArgumentError.checkNotNull(email, 'email');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'email': email};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('users',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => User.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
