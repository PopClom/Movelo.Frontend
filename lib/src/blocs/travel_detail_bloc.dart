import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fletes_31_app/src/utils/flushbar.dart';
import 'package:fletes_31_app/src/utils/helpers.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';
import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/network/travel_api.dart';

class TravelDetailBloc {
  final apiService = TravelAPI(Dio());

  final BehaviorSubject<Travel> _travel = BehaviorSubject<Travel>();
  final BehaviorSubject<bool> _isSubmitting = BehaviorSubject<bool>.seeded(false);

  Stream<List<Marker>> get originAndDestinationMarkers => _travel.map((travel) {
    return [
      _locationToMarker(travel.origin, "Origen"),
      _locationToMarker(travel.destination, "Destino"),
    ];
  });
  Function(bool) get changeIsSubmitting => _isSubmitting.sink.add;

  BehaviorSubject<Travel> get travel => _travel;
  Stream<bool> get isSubmitting => _isSubmitting.stream;

  Future<void> fetchTravel(int id) async {
    Travel travel = await apiService.getTravelById(id);
    _travel.sink.add(travel);
  }

  Future<void> claimTravel(int id, int vehicleId) async {
    try {
      changeIsSubmitting(true);
      Travel travel = await apiService.claimTravel(id, vehicleId);
      _travel.sink.add(travel);
      changeIsSubmitting(false);
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudo aceptar este envío.'
        );
      }
    } finally {
      changeIsSubmitting(false);
    }
  }

  Future<void> startTravel(int id) async {
    try {
      changeIsSubmitting(true);
      Travel travel = await apiService.startTravel(id);
      _travel.sink.add(travel);
      changeIsSubmitting(false);
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudo iniciar este envío.'
        );
      }
    } finally {
      changeIsSubmitting(false);
    }
  }

  Future<void> endTravel(int id) async {
    try {
      changeIsSubmitting(true);
      Travel travel = await apiService.confirmDelivery(id);
      _travel.sink.add(travel);
      changeIsSubmitting(false);
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudo finalizar este envío.'
        );
      }
    } finally {
      changeIsSubmitting(false);
    }
  }

  Future<void> cancelTravel(int id) async {
    try {
      changeIsSubmitting(true);
      Travel travel = await apiService.cancelTravel(id);
      _travel.sink.add(travel);
      changeIsSubmitting(false);
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudo cancelar este envío.'
        );
      }
    } finally {
      changeIsSubmitting(false);
    }
  }

  Marker _locationToMarker(Location location, String name) {
    return new Marker(
      markerId: MarkerId("${name}_${DateTime.now().millisecondsSinceEpoch}"),
      position: LatLng(location.lat, location.lng),
      infoWindow: InfoWindow(
        title: name,
        snippet: location.name.split(",")[0],
      ),
    );
  }

  dispose() {
    _travel.close();
    _isSubmitting.close();
  }
}