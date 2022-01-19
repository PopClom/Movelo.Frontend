import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/dtos/device_register_dto.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fletes_31_app/src/models/profile_device_data_model.dart';
import 'package:fletes_31_app/src/models/paged_list_model.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/models/vehicle_model.dart';
import 'package:fletes_31_app/src/models/check_email_model.dart';
import 'package:fletes_31_app/src/network/authentication_interceptor.dart';
import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:fletes_31_app/src/utils/constants.dart' as Constants;

part 'users_api.g.dart';

@RestApi(baseUrl: Constants.API_BASE_URL + 'profiles/')
abstract class UsersAPI {
  factory UsersAPI(Dio dio, {String baseUrl}) {
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(AuthenticationInterceptor());
    return _UsersAPI(dio, baseUrl: baseUrl);
  }

  @GET('current')
  Future<HttpResponse<User>> getCurrentUserWithResponse(@Header('Authorization') String authHeader);

  @GET('current')
  Future<User> getCurrentUser();

  @POST('authenticate')
  Future<HttpResponse<ProfileDeviceData>> authenticateUserWithResponse(
      @Header('Authorization') String authHeader,
      @Body() DeviceRegister deviceRegister);

  @POST('clients')
  Future<String> createUser(@Body() User user);

  @GET('verify-email')
  Future<CheckEmail> checkEmailAvailable(@Query('email') String email);

  @GET('clients/{id}/travels')
  Future<PagedList<Travel>> getClientTravels(
      @Path('id') int id,
      @Query('OrderBy.FieldName') String orderByField,
      @Query('OrderBy.Direction') String orderByDirection);

  @GET('drivers/{id}/travels')
  Future<PagedList<Travel>> getDriverTravels(
      @Path('id') int id,
      @Query('OrderBy.FieldName') String orderByField,
      @Query('OrderBy.Direction') String orderByDirection);

  @GET('drivers/{id}/vehicles')
  Future<List<Vehicle>> getDriverVehicles(@Path('id') int id);
}
