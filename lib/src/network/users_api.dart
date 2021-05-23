import 'package:fletes_31_app/src/network/errors_interceptor.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/user_model.dart';

part 'users_api.g.dart';


@RestApi(baseUrl: 'https://localhost:44312/')
abstract class UsersAPI {
  factory UsersAPI(Dio dio, {String baseUrl}) {
    dio.interceptors.add(ErrorInterceptor());
    return _UsersAPI(dio, baseUrl: baseUrl);
  }

  @GET('users/current')
  Future<HttpResponse<User>> getCurrentUserWithResponse(@Header('Authorization') String authHeader);

  @GET('users/current')
  Future<User> getCurrentUser();

  @POST('users')
  Future<String> createUser(@Body() User user);

  @GET('users')
  Future<List<User>> checkEmailAvailable(@Query('email') String email);
}

/*
* .catchError((Object obj) {
      // non-200 error goes here.
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print('Got error : ${res.statusCode} -> ${res.data}');
          break;
        default:
      }
    }
* */