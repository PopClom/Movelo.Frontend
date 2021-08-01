import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';

part 'travel_api.g.dart';


@RestApi(baseUrl: 'https://localhost:44312/api/travels/')
abstract class TravelAPI {
  factory TravelAPI(Dio dio, {String baseUrl}) {
    dio.interceptors.add(ErrorInterceptor());
    return _TravelAPI(dio, baseUrl: baseUrl);
  }

  @GET('')
  Future<List<Travel>> getTravels();

  @GET('{id}')
  Future<Travel> getTravelById(@Path("id") String id);

  @POST('')
  Future<void> createTravelRequest(/* TODO: TravelPricingRequest */);

  @PUT('{id}/confirm')
  Future<void> confirmTravelRequest();

  @PUT('{id}/claim')
  Future<void> claimTravel();

  @PUT('{id}/start')
  Future<void> startTravel();

  /*@PUT('{id}/update_driver_position')
  Future<void> updateDriverPosition(Location location);*/

  @PUT('{id}/confirm_delivery')
  Future<void> confirmDelivery();

  @POST('travels/{id}/confirm')
  Future<void> confirmTravel(@Path("id") String id);
}
