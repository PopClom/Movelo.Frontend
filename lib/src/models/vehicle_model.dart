import 'package:fletes_31_app/src/models/vehicle_type_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class Vehicle {
  int id;
  int vehicleTypeId;
  VehicleType type;
  int ownerId;
  String brand;
  String model;
  String licensePlate;
  bool currentlyActive;

  Vehicle({
    this.id,
    this.vehicleTypeId,
    this.type,
    this.ownerId,
    this.brand,
    this.model,
    this.licensePlate,
    this.currentlyActive,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}