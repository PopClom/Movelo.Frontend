import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:fletes_31_app/src/utils/flushbar.dart';
import 'package:fletes_31_app/src/utils/helpers.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fletes_31_app/src/network/travel_api.dart';

class TravelsBloc {
  final apiService = TravelAPI(Dio());

  final BehaviorSubject<List<Travel>> _travels = BehaviorSubject<List<Travel>>();

  BehaviorSubject<List<Travel>> get travels => _travels;

  Future<void> fetchTravels() async {
    try {
      List<Travel> travels = await apiService.getTravels();
      _travels.sink.add(travels);
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudieron cargar tus envíos'
        );
      }
    }

    /*List<Travel> travels = [new Travel(
        id: 5,
        requestedVehicleType: VehicleType(name: "Auto"),
        origin: Location(),
        destination: Location(),
        status: TravelStatus.PendingDriver,
        estimatedPrice: 4500
    )];*/
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