import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/dtos/generate_bearer_token_dto.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fletes_31_app/src/models/dtos/device_register_dto.dart';
import 'package:fletes_31_app/src/utils/notification.dart';
import 'package:fletes_31_app/src/models/vehicle_model.dart';
import 'package:fletes_31_app/src/models/check_email_model.dart';
import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:fletes_31_app/src/models/dtos/login_dto.dart';
import 'package:fletes_31_app/src/models/dtos/authentication_result_dto.dart';
import 'package:fletes_31_app/src/network/auth_api.dart';
import 'package:fletes_31_app/src/network/users_api.dart';
import 'package:fletes_31_app/src/blocs/user_bloc.dart';

class AuthBloc {
  String _bearerTokenString = '';
  String _refreshTokenString = '';
  int _userId = 0;
  String _userType = '';
  int _deviceId = 0;
  DateTime _tokenExpiration;
  final authApi = AuthAPI(Dio());
  final usersApi = UsersAPI(Dio());

  final BehaviorSubject<bool> _isSessionValid = BehaviorSubject<bool>();
  ValueStream<bool> get isSessionValid => _isSessionValid.stream;

  Future<void> logIn(String email, String password) async {
    return authApi.authenticate(Login(
      schema: LoginSchema.Password,
      usernameOrToken: email,
      password: password,
      deviceData: await _getDeviceData(),
    )).then(_handleLogin);
  }

  Future<void> logInFacebook(String token) async {
    return authApi.authenticate(Login(
      schema: LoginSchema.Facebook,
      usernameOrToken: token,
      deviceData: await _getDeviceData(),
    )).then(_handleLogin);
  }

  Future<void> logInGoogle(String token) async {
    return authApi.authenticate(Login(
      schema: LoginSchema.Google,
      usernameOrToken: token,
      deviceData: await _getDeviceData(),
    )).then(_handleLogin);
  }

  Future<DeviceRegister> _getDeviceData() async {
    final firebaseMessaging = FCM();
    String notificationToken = await firebaseMessaging.setNotifications();
    return DeviceRegister(
      notificationToken: notificationToken,
      platform: "Android",
      platformVersion: "11.0.1",
    );
  }

  void _handleLogin(AuthenticationResult authenticationResult) async {
    User user = authenticationResult.profile;
    userBloc.setUser(user);
    await authBloc.openSession(authenticationResult);
    if (isDriver()) {
      List<Vehicle> vehicles = await usersApi.getDriverVehicles(user.id);
      userBloc.setVehicles(vehicles);
    }
  }

  Future<void> signUp(String email, String password, String firstName, String lastName, String phone) {
    return authApi.createUser(User(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    ));
  }

  Future<bool> isEmailAvailable(String email) async {
    CheckEmail result = await authApi.checkEmailAvailable(email);
    return result.available;
  }

  Future<void> restoreSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _bearerTokenString = prefs.get('bearerToken');
    _refreshTokenString = prefs.get('refreshToken');
    _userId = prefs.get('userId');
    _userType = prefs.get('userType');
    _deviceId = prefs.get('deviceId');
    _tokenExpiration = DateTime.now();
    if (_bearerTokenString != null && _bearerTokenString.length > 0 &&
        _userType != null && _userType.length > 0 &&
        _userId != null && _userId > 0 &&
        _deviceId != null && _deviceId > 0) {
      _isSessionValid.sink.add(true);
      userBloc.fetchUser();
    } else {
      _isSessionValid.sink.add(false);
    }
  }

  Future<void> openSession(AuthenticationResult authenticationResult) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('bearerToken', authenticationResult.bearerToken);
    await prefs.setString('refreshToken', authenticationResult.refreshToken);
    await prefs.setInt('userId', authenticationResult.profile.id);
    await prefs.setString('userType', authenticationResult.profile.profileType);
    await prefs.setInt('deviceId', authenticationResult.uniqueDeviceId);
    _bearerTokenString = authenticationResult.bearerToken;
    _refreshTokenString = authenticationResult.refreshToken;
    _userId = authenticationResult.profile.id;
    _userType = authenticationResult.profile.profileType;
    _deviceId = authenticationResult.uniqueDeviceId;
    _tokenExpiration = DateTime.now().add(const Duration(minutes: 5));
    _isSessionValid.sink.add(true);
  }

  Future<void> closeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('bearerToken');
    prefs.remove('refreshToken');
    prefs.remove('userId');
    prefs.remove('userType');
    prefs.remove('deviceId');
    _isSessionValid.sink.add(false);
  }

  Future<bool> createBearerToken() async {
    try {
      String newBearerToken = await authApi.createBearerToken(
        _userId,
        _deviceId,
        GenerateBearerToken(refreshToken: _refreshTokenString),
      );
      _bearerTokenString = newBearerToken;
      _tokenExpiration = DateTime.now().add(const Duration(minutes: 5));
    } catch (err) {
      return false;
    }
    return true;
  }

  String getBearerToken() {
    return _bearerTokenString;
  }

  String getRefreshToken() {
    return _refreshTokenString;
  }

  bool isDriver() {
    return _userType == 'Driver';
  }

  bool isClient() {
    return _userType == 'Client';
  }

  int getUserId() {
    return _userId != null ? _userId : 0;
  }

  int getDeviceId() {
    return _deviceId != null ? _deviceId : 0;
  }

  bool hasSessionExpired() {
    return DateTime.now().isAfter(
        _tokenExpiration.subtract(const Duration(seconds: 15))
    );
  }

  void dispose() {
    _isSessionValid.close();
  }
}

final authBloc = AuthBloc();
