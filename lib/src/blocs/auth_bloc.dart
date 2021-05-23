import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fletes_31_app/src/network/users_api.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/blocs/user_bloc.dart';


class AuthBloc {
  String _tokenString = "";
  final apiService = UsersAPI(Dio());

  final PublishSubject _isSessionValid = PublishSubject<bool>();
  Stream<bool> get isSessionValid => _isSessionValid.stream;

  Future<void> logIn(String email, String password) async {
    apiService.getCurrentUserWithResponse("Basic $email:$password")
        .then((response) {
          String token = response.response.headers.value("Authorization");
          User user = response.data;
          userBloc.setUser(user);
          authBloc.openSession(token);
    });
  }

  Future<void> signUp(String email, String password, String firstName, String lastName, String phone) async {
    return apiService.createUser(User(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    )).then((user) {
      // authBloc.openSession(token);
    });
  }

  Future<void> restoreSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokenString = prefs.get("token");
    if (_tokenString != null && _tokenString.length > 0) {
      _isSessionValid.sink.add(true);
    } else {
      _isSessionValid.sink.add(false);
    }
  }

  Future<void> openSession(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    _tokenString = token;
    _isSessionValid.sink.add(true);
  }

  Future<void> closeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    _isSessionValid.sink.add(false);
  }

  void dispose() {
    _isSessionValid.close();
  }
}

final authBloc = AuthBloc();
