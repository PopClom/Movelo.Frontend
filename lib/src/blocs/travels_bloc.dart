import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fletes_31_app/src/models/travel_list_model.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/network/travel_api.dart';
import 'package:fletes_31_app/src/blocs/auth_bloc.dart';
import 'package:fletes_31_app/src/utils/flushbar.dart';
import 'package:fletes_31_app/src/utils/helpers.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';
import 'package:fletes_31_app/src/network/users_api.dart';

class TravelsBloc {
  final usersApi = UsersAPI(Dio());
  final travelApi = TravelAPI(Dio());

  final BehaviorSubject<List<Travel>> _travels = BehaviorSubject<List<Travel>>();
  final BehaviorSubject<List<Travel>> _potentialTravels = BehaviorSubject<List<Travel>>();

  BehaviorSubject<List<Travel>> get travels => _travels;
  BehaviorSubject<List<Travel>> get potentialTravels => _potentialTravels;

  Future<void> fetchTravels() async {
    try {
      if (authBloc.isClient()) {
        TravelList travels = await usersApi.getClientTravels(authBloc.getUserId());
        _travels.sink.add(travels.data);
      } else {
        TravelList travels = await usersApi.getDriverTravels(authBloc.getUserId());
        List<Travel> potentialTravels = await travelApi.getPotentialTravels();
        _travels.sink.add(travels.data);
        _potentialTravels.sink.add(potentialTravels);
      }
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudieron cargar tus envíos.'
        );
      }
    }
  }

  void updateTravel(Travel travel) {
    Travel travelToUpdate = _travels.value.firstWhere(
            (elem) => elem.id == travel.id, orElse: () => null);

    if (travelToUpdate != null) {
      _travels.value.remove(travelToUpdate);
    }

    _travels.value.add(travel);
    _travels.sink.add(_travels.value);
  }

  dispose() {
    _travels.close();
    _potentialTravels.close();
  }
}