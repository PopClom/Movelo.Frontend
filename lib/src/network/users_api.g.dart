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
  Future<HttpResponse<ProfileDeviceData>> authenticateUserWithResponse(
      authHeader, deviceRegister) async {
    ArgumentError.checkNotNull(authHeader, 'authHeader');
    ArgumentError.checkNotNull(deviceRegister, 'deviceRegister');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(deviceRegister?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('authenticate',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': authHeader},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ProfileDeviceData.fromJson(_result.data);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<String> createUser(user) async {
    ArgumentError.checkNotNull(user, 'user');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(user?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<String>('clients',
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
  Future<CheckEmail> checkEmailAvailable(email) async {
    ArgumentError.checkNotNull(email, 'email');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'email': email};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('verify-email',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = CheckEmail.fromJson(_result.data);
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
