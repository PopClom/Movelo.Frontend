import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/utils/flushbar.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';


class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err) {
    if ([
      DioErrorType.RECEIVE_TIMEOUT,
      DioErrorType.SEND_TIMEOUT,
      DioErrorType.CANCEL,
      DioErrorType.DEFAULT,
    ].contains(err.type)){
      print(err.message);
      showErrorToast(
          Navigation.navigationKey.currentContext,
          'Ocurrió un error', 'No se pudo procesar esta operación'
      );
    } else if (err.type == DioErrorType.CONNECT_TIMEOUT) {
      showErrorToast(
          Navigation.navigationKey.currentContext,
          'Error de conexión', 'Parece que no tenés conexión a internet'
      );
    } else if (err.type == DioErrorType.RESPONSE) {
      if (err.response == null) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Error de conexión', 'Parece que no tenés conexión a internet'
        );
      } else if (err.response.statusCode >= 500) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Tuvimos un problema', '¡Lo sentimos! No pudimos procesar tu pedido'
        );
      }
    }

    return super.onError(err);
  }
}
