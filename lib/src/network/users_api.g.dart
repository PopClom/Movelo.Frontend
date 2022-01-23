// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _UsersAPI implements UsersAPI {
  _UsersAPI(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://localhost:44312/api/profiles/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<HttpResponse<User>> getCurrentUserWithResponse(authHeader) async {
    ArgumentError.checkNotNull(authHeader, 'authHeader');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('current',
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
    final _result = await _dio.request<Map<String, dynamic>>('current',
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
  Future<PagedList<Travel>> getClientTravels(
      id, orderByField, orderByDirection) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(orderByField, 'orderByField');
    ArgumentError.checkNotNull(orderByDirection, 'orderByDirection');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'OrderBy.FieldName': orderByField,
      r'OrderBy.Direction': orderByDirection
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'clients/$id/travels',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PagedList<Travel>.fromJson(
      _result.data,
      (json) => Travel.fromJson(json),
    );
    return value;
  }

  @override
  Future<PagedList<Travel>> getDriverTravels(
      id, orderByField, orderByDirection) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(orderByField, 'orderByField');
    ArgumentError.checkNotNull(orderByDirection, 'orderByDirection');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'OrderBy.FieldName': orderByField,
      r'OrderBy.Direction': orderByDirection
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'drivers/$id/travels',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PagedList<Travel>.fromJson(
      _result.data,
      (json) => Travel.fromJson(json),
    );
    return value;
  }

  @override
  Future<List<Vehicle>> getDriverVehicles(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('drivers/$id/vehicles',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => Vehicle.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
