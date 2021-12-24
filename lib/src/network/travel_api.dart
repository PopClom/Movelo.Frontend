import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fletes_31_app/src/models/dtos/travel_create_dto.dart';
import 'package:fletes_31_app/src/models/dtos/travel_pricing_request_dto.dart';
import 'package:fletes_31_app/src/models/dtos/travel_pricing_result_dto.dart';
import 'package:fletes_31_app/src/network/authentication_interceptor.dart';
import 'package:fletes_31_app/src/network/errors_interceptor.dart';
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

  @GET('{id}')
  Future<Travel> getTravelById(@Path("id") int id);

  @GET('potential')
  Future<List<Travel>> getPotentialTravels();

  @POST('')
  Future<TravelPricingResult> createTravelRequest(@Body() TravelPricingRequest travelPricingRequest);

  @PUT('confirm')
  Future<Travel> confirmTravelRequest(@Body() TravelCreate travelCreate);

  @PUT('{id}/claim')
  Future<Travel> claimTravel(@Path("id") int id, @Body() int vehicleId);

  @PUT('{id}/start')
  Future<Travel> startTravel(@Path("id") int id);

  /*@PUT('{id}/update_driver_position')
  Future<void> updateDriverPosition(Location location);*/

  @PUT('{id}/confirm_delivery')
  Future<Travel> confirmDelivery();
}
