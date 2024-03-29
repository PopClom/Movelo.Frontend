// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_type_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _VehicleTypeAPI implements VehicleTypeAPI {
  _VehicleTypeAPI(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://movelo.com.ar/api/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<List<VehicleType>> getVehicleTypes() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('vehicle-types',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => VehicleType.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
