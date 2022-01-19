import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/route_model.dart';
import 'package:fletes_31_app/src/models/user_model.dart';
import 'package:fletes_31_app/src/models/vehicle_model.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'travel_model.g.dart';

enum TravelStatus {
  PendingClientConfirmation,
  PendingDriver,
  ConfirmedAndPendingStart,
  DrivingTowardsOrigin,
  ArrivedAtOrigin,
  DrivingTowardsDestination,
  ArrivedAtDestination,
  Completed,
  CancelledByClient,
  CancelledByTimeout
}

extension TravelStatusExt on TravelStatus {
  static const Map<TravelStatus, String> labels = {
    TravelStatus.PendingClientConfirmation: 'Esperando confirmación',
    TravelStatus.PendingDriver: 'Buscando conductor',
    TravelStatus.ConfirmedAndPendingStart: 'Confirmado',
    TravelStatus.DrivingTowardsOrigin: 'Yendo a buscar envío',
    TravelStatus.ArrivedAtOrigin: 'Cargando envío',
    TravelStatus.DrivingTowardsDestination: 'En curso',
    TravelStatus.ArrivedAtDestination: 'Desargando envío',
    TravelStatus.Completed: 'Entregado',
    TravelStatus.CancelledByClient: 'Cancelado',
    TravelStatus.CancelledByTimeout: 'Conductor no encontrado',
  };

  String get label => labels[this];
}


@JsonSerializable()
class Travel {
  int id;
  int requestingUserId;
  User requestingUser;
  VehicleType requestedVehicleType;
  TravelStatus status;
  int driverId;
  User driver;
  Vehicle vehicle;
  bool driverHandlesLoading;
  bool driverHandlesUnloading;
  bool fitsInElevator;
  int requiredAssistants;
  int numberOfFloors;
  String transportedObjectDescription;
  DateTime requestedDepatureTime;

  Location origin;
  Location destination;
  Location driverCurrentLocation;

  double estimatedPrice;
  Route estimatedRoute;

  Travel({
    this.id,
    this.requestingUser,
    this.requestingUserId,
    this.requestedVehicleType,
    this.status,
    this.driverId,
    this.driver,
    this.vehicle,
    this.driverHandlesLoading,
    this.driverHandlesUnloading,
    this.fitsInElevator,
    this.requiredAssistants,
    this.numberOfFloors,
    this.transportedObjectDescription,
    this.requestedDepatureTime,
    this.origin,
    this.destination,
    this.driverCurrentLocation,
    this.estimatedPrice,
    this.estimatedRoute,
  });

  factory Travel.fromJson(Map<String, dynamic> json) => _$TravelFromJson(json);
  Map<String, dynamic> toJson() => _$TravelToJson(this);
}