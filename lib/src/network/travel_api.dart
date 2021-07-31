import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';

part 'travel_api.g.dart';


@RestApi(baseUrl: 'https://localhost:44312/')
abstract class TravelAPI {
  factory TravelAPI(Dio dio, {String baseUrl}) {
    dio.interceptors.add(ErrorInterceptor());
    return _TravelAPI(dio, baseUrl: baseUrl);
  }

  @GET('travels')
  Future<List<Travel>> getTravels();

  @GET('travels/{id}')
  Future<Travel> getTravel(@Path("id") String id);

  @POST('travels/{id}/confirm')
  Future<void> confirmTravel(@Path("id") String id);
}
