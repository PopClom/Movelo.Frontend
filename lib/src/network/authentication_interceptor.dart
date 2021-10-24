import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/blocs/auth_bloc.dart';

class AuthenticationInterceptor extends Interceptor {

  @override
  Future onRequest(RequestOptions options) {
    if (authBloc.isSessionValid.hasValue && authBloc.isSessionValid.value) {
      options.headers['authorization'] = authBloc.getToken();
    }
    return super.onRequest(options);
  }
}
