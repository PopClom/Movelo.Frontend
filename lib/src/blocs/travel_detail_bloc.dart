import 'dart:async';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fletes_31_app/src/blocs/auth_bloc.dart';
import 'package:fletes_31_app/src/utils/flushbar.dart';
import 'package:fletes_31_app/src/utils/helpers.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';
import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:fletes_31_app/src/network/travel_api.dart';

class TravelDetailBloc {
  final apiService = TravelAPI(Dio());

  final BehaviorSubject<Travel> _travel = BehaviorSubject<Travel>();
  final BehaviorSubject<Marker> _driverPosition = BehaviorSubject<Marker>.seeded(null);
  final BehaviorSubject<bool> _isSubmitting = BehaviorSubject<bool>.seeded(false);

  Stream<List<Marker>> get markers =>
      Rx.combineLatest2(_travel, _driverPosition, (Travel t, Marker m) {
        List<Marker> originAndDestination = [
          _locationToMarker(t.origin, 'Origen'),
          _locationToMarker(t.destination, 'Destino'),
        ];
        return m != null ? [...originAndDestination, m] : originAndDestination;
      });

  Function(bool) get changeIsSubmitting => _isSubmitting.sink.add;

  BehaviorSubject<Travel> get travel => _travel;
  BehaviorSubject<bool> get isSubmitting => _isSubmitting.stream;

  BitmapDescriptor _customIcon = BitmapDescriptor.defaultMarker;
  Timer timer;

  Future<void> fetchTravel(int id) async {
    await _updateTravel(id);
    _configureLocation();
  }

  Future<void> _updateTravel(int id) async {
    Travel travel = await apiService.getTravelById(id);
    _travel.sink.add(travel);
    if (_shouldTrackTravel(travel.status) && travel.driverCurrentLocation != null) {
      _driverPosition.sink.add(_driverMarker(
          travel.driverCurrentLocation.lat,
          travel.driverCurrentLocation.lng,
          'Conductor'
      ));
    }
  }

  void _configureLocation() async {
    _customIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(60, 60)), 'assets/images/marker.png'
    );

    if (_travel.hasValue && _shouldTrackTravel(_travel.value.status) && authBloc.isDriver()) {
      _startTracking();
    }

    timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
      if (_travel.hasValue) {
        if (authBloc.isDriver()) {
          if (_driverPosition.hasValue && _driverPosition.value != null && _shouldTrackTravel(_travel.value.status)) {
            apiService.updateDriverPosition(
              _travel.value.id,
              _markerToLocation(_driverPosition.value, 'Conductor'),
            );
          }
        } else {
          _updateTravel(_travel.value.id);
        }
      }
    });
  }

  void _startTracking() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      _driverPosition.sink.add(_driverMarker(position.latitude, position.longitude, 'Conductor'));
    }).onError((err) {
      // Ignore error
    });
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
      _startTracking();
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

  Future<void> confirmArrivedAtOrigin(int id) async {
    try {
      changeIsSubmitting(true);
      Travel travel = await apiService.confirmArrivedAtOrigin(id);
      _travel.sink.add(travel);
      changeIsSubmitting(false);
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudo indicar la llegada al punto de partida.'
        );
      }
    } finally {
      changeIsSubmitting(false);
    }
  }

  Future<void> confirmDrivingTowardsDestination(int id) async {
    try {
      changeIsSubmitting(true);
      Travel travel = await apiService.confirmDrivingTowardsDestination(id);
      _travel.sink.add(travel);
      changeIsSubmitting(false);
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudo indicar el viaje al destino.'
        );
      }
    } finally {
      changeIsSubmitting(false);
    }
  }

  Future<void> confirmArrivedAtDestination(int id) async {
    try {
      changeIsSubmitting(true);
      Travel travel = await apiService.confirmArrivedAtDestination(id);
      _travel.sink.add(travel);
      changeIsSubmitting(false);
    } catch(err) {
      if (is4xxError(err)) {
        showErrorToast(
            Navigation.navigationKey.currentContext,
            'Ocurrió un error', 'No se pudo indicar la llegada al destino.'
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
      markerId: MarkerId('${name}_${DateTime.now().millisecondsSinceEpoch}'),
      position: LatLng(location.lat, location.lng),
      infoWindow: InfoWindow(
        title: name,
        snippet: location.name.split(',')[0],
      ),
    );
  }

  Location _markerToLocation(Marker marker, String name) {
    return new Location(
      lat: marker.position.latitude,
      lng: marker.position.longitude,
      name: name,
    );
  }

  Marker _driverMarker(double lat, double lng, String name) {
    return new Marker(
      markerId: MarkerId('${name}_${DateTime.now().millisecondsSinceEpoch}'),
      position: LatLng(lat, lng),
      icon: _customIcon,
      infoWindow: InfoWindow(
        title: name,
        snippet: name,
      ),
    );
  }

  bool _shouldTrackTravel(TravelStatus status) {
    return status == TravelStatus.DrivingTowardsOrigin
        || status == TravelStatus.ArrivedAtOrigin
        || status == TravelStatus.DrivingTowardsDestination
        || status == TravelStatus.ArrivedAtDestination;
  }

  dispose() {
    _travel.close();
    _driverPosition.close();
    _isSubmitting.close();
    timer.cancel();
  }
}