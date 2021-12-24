import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fletes_31_app/src/models/vehicle_model.dart';
import 'package:fletes_31_app/src/models/check_email_model.dart';
import 'package:fletes_31_app/src/models/travel_list_model.dart';
import 'package:fletes_31_app/src/network/authentication_interceptor.dart';
import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:fletes_31_app/src/utils/constants.dart' as Constants;

part 'users_api.g.dart';

@RestApi(baseUrl: Constants.BASE_URL + 'profiles/')
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

  @POST('clients')
  Future<String> createUser(@Body() User user);

  @GET('verify-email')
  Future<CheckEmail> checkEmailAvailable(@Query('email') String email);

  @GET('clients/{id}/travels')
  Future<TravelList> getClientTravels(@Path('id') id);

  @GET('drivers/{id}/travels')
  Future<TravelList> getDriverTravels(@Path('id') id);

  @GET('drivers/{id}/vehicles')
  Future<List<Vehicle>> getDriverVehicles(@Path('id') id);
}
