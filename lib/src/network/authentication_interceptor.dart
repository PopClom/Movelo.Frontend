import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/blocs/auth_bloc.dart';

class AuthenticationInterceptor extends Interceptor {
  static final Dio _dio = Dio();

  @override
  Future onRequest(RequestOptions options) async {
    if (authBloc.isSessionValid.hasValue && authBloc.isSessionValid.value) {
      bool _bearerTokenHasExpired = authBloc.hasSessionExpired();
      bool _refreshed = true;

      if (_bearerTokenHasExpired) {
        // regenerate bearer token
        _dio.interceptors.requestLock.lock();
        _refreshed = await authBloc.createBearerToken();
        _dio.interceptors.requestLock.unlock();
      }

      if (_refreshed) {
        options.headers['authorization'] = 'Bearer ${authBloc.getBearerToken()}';
      } else {
        authBloc.closeSession();

        final error = DioError(
          request: options,
          type: DioErrorType.DEFAULT,
          error: "session_expired",
        );

        return error;
      }
    }

    return super.onRequest(options);
  }
}
