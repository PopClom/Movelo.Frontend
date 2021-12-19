import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/network/users_api.dart';


class UserBloc {
  final apiService = UsersAPI(Dio());

  final BehaviorSubject<User> _user = BehaviorSubject<User>();

  BehaviorSubject<User> get user => _user;

  void setUser(User user) {
    _user.sink.add(user);
  }

  Future<void> fetchUser() async {
    User user = await apiService.getCurrentUser();
    _user.sink.add(user);
  }

  dispose() {
    _user.close();
  }
}

final userBloc = UserBloc();
