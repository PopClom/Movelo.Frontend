import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/models/route_model.dart';
import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'travel_model.g.dart';

enum TravelStatus {
  PendingUserConfirmation,
  PendingDriver,
  ConfirmedAndPendingStart,
  InProcess,
  Completed
}

extension TravelStatusExt on TravelStatus {
  static const Map<TravelStatus, String> labels = {
    TravelStatus.Completed: 'Completado',
    TravelStatus.ConfirmedAndPendingStart: 'Confirmado',
    TravelStatus.PendingDriver: 'Buscando conductor',
    TravelStatus.InProcess: 'En curso',
    TravelStatus.PendingUserConfirmation: 'Esperando confirmación',
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
    this.origin,
    this.destination,
    this.estimatedPrice,
    this.estimatedRoute,
  });

  factory Travel.fromJson(Map<String, dynamic> json) => _$TravelFromJson(json);
  Map<String, dynamic> toJson() => _$TravelToJson(this);
}