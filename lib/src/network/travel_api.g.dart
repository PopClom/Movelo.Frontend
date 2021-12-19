// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _TravelAPI implements TravelAPI {
  _TravelAPI(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://localhost:44312/api/travels/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<Travel> getTravelById(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('$id',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Travel.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<Travel>> getPotentialTravels() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('potential',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => Travel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<TravelPricingResult> createTravelRequest(travelPricingRequest) async {
    ArgumentError.checkNotNull(travelPricingRequest, 'travelPricingRequest');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(travelPricingRequest?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = TravelPricingResult.fromJson(_result.data);
    return value;
  }

  @override
  Future<Travel> confirmTravelRequest(travelCreate) async {
    ArgumentError.checkNotNull(travelCreate, 'travelCreate');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(travelCreate?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('confirm',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Travel.fromJson(_result.data);
    return value;
  }

  @override
  Future<void> claimTravel(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    await _dio.request<void>('$id/claim',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    return null;
  }

  @override
  Future<void> startTravel(id) async {
    ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    await _dio.request<void>('$id/start',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    return null;
  }

  @override
  Future<void> confirmDelivery() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    await _dio.request<void>('{id}/confirm_delivery',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    return null;
  }
}
