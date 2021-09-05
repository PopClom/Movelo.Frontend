import 'package:fletes_31_app/src/models/check_email_model.dart';
import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fletes_31_app/src/network/users_api.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fletes_31_app/src/blocs/user_bloc.dart';
import 'dart:convert';


class AuthBloc {
  String _tokenString = '';
  final apiService = UsersAPI(Dio());

  final BehaviorSubject<bool> _isSessionValid = BehaviorSubject<bool>();
  ValueStream<bool> get isSessionValid => _isSessionValid.stream;

  Future<void> logIn(String email, String password) {
    String encodedCredentials = base64.encode(utf8.encode('$email:$password'));
    return apiService.getCurrentUserWithResponse('Basic $encodedCredentials')
        .then(_handleLogin);
  }

  Future<void> logInFacebook(String token) {
    return apiService.getCurrentUserWithResponse('Facebook $token')
        .then(_handleLogin);
  }

  Future<void> logInGoogle(String token) {
    return apiService.getCurrentUserWithResponse('Google $token')
        .then(_handleLogin);
  }

  void _handleLogin(HttpResponse<User> response) {
    String token = response.response.headers.value('Authorization');
    User user = response.data;
    userBloc.setUser(user);
    authBloc.openSession(token);
  }

  Future<void> signUp(String email, String password, String firstName, String lastName, String phone) {
    return apiService.createUser(User(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    )).then((user) {
      // ToDo: authBloc.openSession(token);
    });
  }

  Future<bool> isEmailAvailable(String email) async {
    CheckEmail result = await apiService.checkEmailAvailable(email);
    return result.available;
  }

  Future<void> restoreSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokenString = prefs.get('token');
    if (_tokenString != null && _tokenString.length > 0) {
      _isSessionValid.sink.add(true);
    } else {
      _isSessionValid.sink.add(false);
    }
  }

  Future<void> openSession(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _tokenString = token;
    _isSessionValid.sink.add(true);
  }

  Future<void> closeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    _isSessionValid.sink.add(false);
  }

  void dispose() {
    _isSessionValid.close();
  }
}

final authBloc = AuthBloc();
