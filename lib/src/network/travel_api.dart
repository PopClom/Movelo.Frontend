import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/dtos/travel_create_dto.dart';
import 'package:fletes_31_app/src/models/dtos/travel_pricing_request_dto.dart';
import 'package:fletes_31_app/src/models/dtos/travel_pricing_result_dto.dart';
import 'package:fletes_31_app/src/network/authentication_interceptor.dart';
import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/utils/constants.dart' as Constants;

part 'travel_api.g.dart';

@RestApi(baseUrl: Constants.API_BASE_URL + 'travels/')
abstract class TravelAPI {
  factory TravelAPI(Dio dio, {String baseUrl}) {
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(AuthenticationInterceptor());
    return _TravelAPI(dio, baseUrl: baseUrl);
  }

  @GET('{id}')
  Future<Travel> getTravelById(@Path('id') int id);

  @GET('potential')
  Future<List<Travel>> getPotentialTravels();

  @POST('')
  Future<TravelPricingResult> createTravelRequest(@Body() TravelPricingRequest travelPricingRequest);

  @PUT('confirm')
  Future<Travel> confirmTravelRequest(@Body() TravelCreate travelCreate);

  @PUT('{id}/claim')
  Future<Travel> claimTravel(@Path('id') int id, @Body() int vehicleId);

  @PUT('{id}/start')
  Future<Travel> startTravel(@Path('id') int id);

  @PUT('{id}/confirm-arrived-origin')
  Future<Travel> confirmArrivedAtOrigin(@Path('id') int id);

  @PUT('{id}/confirm-driving-destination')
  Future<Travel> confirmDrivingTowardsDestination(@Path('id') int id);

  @PUT('{id}/confirm-arrived-destination')
  Future<Travel> confirmArrivedAtDestination(@Path('id') int id);

  @PUT('{id}/confirm-delivery')
  Future<Travel> confirmDelivery(@Path('id') int id);

  @PUT('{id}/cancel')
  Future<Travel> cancelTravel(@Path('id') int id);

  @PUT('{id}/driver-position')
  Future<void> updateDriverPosition(@Path('id') int id, @Body() Location location);

  @GET('{id}/driver-position')
  Future<Location> getDriverPosition(@Path('id') int id);
}
