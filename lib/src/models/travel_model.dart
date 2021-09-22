import 'package:fletes_31_app/src/models/route_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'travel_model.g.dart';

/*enum TravelStatus {
  PendingUserConfirmation,
  PendingDriver,
  ConfirmedAndPendingStart,
  InProcess,
  Completed
}*/

/*extension TravelStatusExt on TravelStatus {
  static const Map<TravelStatus, String> labels = {
    TravelStatus.Completed: 'Completado',
    TravelStatus.ConfirmedAndPendingStart: 'Confirmado',
    TravelStatus.PendingDriver: 'Buscando conductor',
    TravelStatus.InProcess: 'En curso',
    TravelStatus.PendingUserConfirmation: 'Esperando confirmación',
  };

  String get label => labels[this];
}*/


@JsonSerializable()
class Travel {
  int id;
  int requestingUserId;
  int requestedVehicleTypeId;
  //TravelStatus status;
  int driverId;

  double estimatedPrice;
  Route estimatedRoute;

  Travel({this.id, this.requestingUserId, this.requestedVehicleTypeId, this.driverId, this.estimatedPrice});

  factory Travel.fromJson(Map<String, dynamic> json) => _$TravelFromJson(json);
  Map<String, dynamic> toJson() => _$TravelToJson(this);
}