import 'package:fletes_31_app/src/models/check_email_model.dart';
import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/user_model.dart';

part 'users_api.g.dart';

@RestApi(baseUrl: 'https://localhost:44312/api/users/')
abstract class UsersAPI {
  factory UsersAPI(Dio dio, {String baseUrl}) {
    dio.interceptors.add(ErrorInterceptor());
    return _UsersAPI(dio, baseUrl: baseUrl);
  }

  @GET('current')
  Future<HttpResponse<User>> getCurrentUserWithResponse(@Header('Authorization') String authHeader);

  @GET('current')
  Future<User> getCurrentUser();

  @POST('')
  Future<String> createUser(@Body() User user);

  @GET('verify-email')
  Future<CheckEmail> checkEmailAvailable(@Query('email') String email);
}
