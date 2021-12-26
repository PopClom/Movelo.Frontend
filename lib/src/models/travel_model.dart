import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/route_model.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'travel_model.g.dart';

enum TravelStatus {
  PendingClientConfirmation,
  PendingDriver,
  ConfirmedAndPendingStart,
  InProgress,
  CancelledByClient,
  Completed
}

extension TravelStatusExt on TravelStatus {
  static const Map<TravelStatus, String> labels = {
    TravelStatus.Completed: 'Entregado',
    TravelStatus.ConfirmedAndPendingStart: 'Confirmado',
    TravelStatus.PendingDriver: 'Buscando conductor',
    TravelStatus.InProgress: 'En curso',
    TravelStatus.CancelledByClient: 'Cancelado',
    TravelStatus.PendingClientConfirmation: 'Esperando confirmación',
  };

  String get label => labels[this];
}


@JsonSerializable()
class Travel {
  int id;
  int requestingUserId;
  VehicleType requestedVehicleType;
  TravelStatus status;
  int driverId;
  bool driverHandlesLoading;
  bool driverHandlesUnloading;
  bool fitsInElevator;
  int requiredAssistants;
  int numberOfFloors;
  String transportedObjectDescription;

  Location origin;
  Location destination;

  double estimatedPrice;
  Route estimatedRoute;

  Travel({
    this.id,
    this.requestingUserId,
    this.requestedVehicleType,
    this.status,
    this.driverId,
    this.driverHandlesLoading,
    this.driverHandlesUnloading,
    this.fitsInElevator,
    this.requiredAssistants,
    this.numberOfFloors,
    this.transportedObjectDescription,
    this.origin,
    this.destination,
    this.estimatedPrice,
    this.estimatedRoute,
  });

  factory Travel.fromJson(Map<String, dynamic> json) => _$TravelFromJson(json);
  Map<String, dynamic> toJson() => _$TravelToJson(this);
}