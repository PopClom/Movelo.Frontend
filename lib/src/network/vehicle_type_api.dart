import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';

part 'vehicle_type_api.g.dart';

@RestApi(baseUrl: 'https://localhost:44312/api/')
abstract class VehicleTypeAPI {
  factory VehicleTypeAPI(Dio dio, {String baseUrl}) {
    dio.interceptors.add(ErrorInterceptor());
    return _VehicleTypeAPI(dio, baseUrl: baseUrl);
  }

  @GET('vehicletypes')
  Future<List<VehicleType>> getVehicleTypes();
}