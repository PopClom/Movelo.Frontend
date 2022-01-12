import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:fletes_31_app/src/utils/constants.dart' as Constants;

part 'chat_api.g.dart';

@RestApi(baseUrl: Constants.BASE_URL + 'chats/')
abstract class ChatAPI {
  factory ChatAPI(Dio dio, {String baseUrl}) {
    dio.interceptors.add(ErrorInterceptor());
    return _ChatAPI(dio, baseUrl: baseUrl);
  }

  @GET('vehicle-types')
  Future<List<VehicleType>> getVehicleTypes();
}