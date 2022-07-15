import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fletes_31_app/src/models/dtos/authentication_result_dto.dart';
import 'package:fletes_31_app/src/models/dtos/login_dto.dart';
import 'package:fletes_31_app/src/models/dtos/generate_bearer_token_dto.dart';
import 'package:fletes_31_app/src/models/check_email_model.dart';
import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:fletes_31_app/src/utils/constants.dart' as Constants;

part 'auth_api.g.dart';

@RestApi(baseUrl: Constants.API_BASE_URL + 'profiles/')
abstract class AuthAPI {
  factory AuthAPI(Dio dio, {String baseUrl}) {
    dio.interceptors.add(ErrorInterceptor());
    return _AuthAPI(dio, baseUrl: baseUrl);
  }

  @POST('authenticate')
  Future<AuthenticationResult> authenticate(@Body() Login login);

  @POST('{profileId}/devices/{deviceId}/create-bearer-token')
  Future<String> createBearerToken(
      @Path('profileId') int profileId,
      @Path('deviceId') int deviceId,
      @Body() GenerateBearerToken generateBearerToken);

  @POST('clients')
  Future<String> createUser(@Body() User user);

  @GET('verify-email')
  Future<CheckEmail> checkEmailAvailable(@Query('email') String email);

}
