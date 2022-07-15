import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fletes_31_app/src/blocs/auth_bloc.dart';
import 'package:fletes_31_app/src/models/vehicle_model.dart';
import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:fletes_31_app/src/network/users_api.dart';


class UserBloc {
  final apiService = UsersAPI(Dio());

  final BehaviorSubject<User> _user = BehaviorSubject<User>();
  final BehaviorSubject<List<Vehicle>> _vehicles = BehaviorSubject<List<Vehicle>>();

  BehaviorSubject<User> get user => _user;
  BehaviorSubject<List<Vehicle>> get vehicles => _vehicles;

  void setUser(User user) {
    _user.sink.add(user);
  }

  void setVehicles(List<Vehicle> vehicles) {
    _vehicles.sink.add(vehicles);
  }

  Future<void> fetchUser() async {
    User user = await apiService.getCurrentUser();
    _user.sink.add(user);
    if (authBloc.isDriver()) {
      List<Vehicle> vehicles = await apiService.getDriverVehicles(user.id);
      _vehicles.sink.add(vehicles);
    }
  }

  dispose() {
    _user.close();
    _vehicles.close();
  }
}

final userBloc = UserBloc();
