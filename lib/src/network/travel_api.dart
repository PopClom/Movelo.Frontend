import 'package:fletes_31_app/src/models/travel_pricing_request_model.dart';
import 'package:fletes_31_app/src/network/authentication_interceptor.dart';
import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/utils/constants.dart' as Constants;

part 'travel_api.g.dart';

@RestApi(baseUrl: Constants.BASE_URL + 'travels/')
abstract class TravelAPI {
  factory TravelAPI(Dio dio, {String baseUrl}) {
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(AuthenticationInterceptor());
    return _TravelAPI(dio, baseUrl: baseUrl);
  }

  @GET('')
  Future<List<Travel>> getTravels();

  @GET('{id}')
  Future<Travel> getTravelById(@Path("id") int id);

  @POST('')
  Future<Travel> createTravelRequest(@Body() TravelPricingRequest travelPricingRequest);

  @PUT('{id}/confirm')
  Future<void> confirmTravelRequest(@Path("id") int id);

  @PUT('{id}/claim')
  Future<void> claimTravel(@Path("id") int id);

  @PUT('{id}/start')
  Future<void> startTravel(@Path("id") int id);

  /*@PUT('{id}/update_driver_position')
  Future<void> updateDriverPosition(Location location);*/

  @PUT('{id}/confirm_delivery')
  Future<void> confirmDelivery();
}
