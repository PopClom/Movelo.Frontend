import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fletes_31_app/src/network/travel_api.dart';

class TravelsBloc {
  final apiService = TravelAPI(Dio());

  final BehaviorSubject<List<Travel>> _travels = BehaviorSubject<List<Travel>>();

  BehaviorSubject<List<Travel>> get travels => _travels;

  Future<void> fetchTravels() async {
    //List<Travel> travels = await apiService.getTravels();
    List<Travel> travels = [new Travel(id: 5, status: TravelStatus.PendingDriver, price: 4500)];
    _travels.sink.add(travels);
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
  }
}