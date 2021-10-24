import 'package:json_annotation/json_annotation.dart';

part 'vehicle_type_model.g.dart';


@JsonSerializable()
class VehicleType {
  int id;
  String name;
  String imageUrl;
  double maxWeightInKilograms;
  double widthInMeters;
  double heightInMeters;
  double depthInMeters;

  VehicleType(
      {this.id,
        this.name,
        this.imageUrl,
        this.maxWeightInKilograms,
        this.widthInMeters,
        this.heightInMeters,
        this.depthInMeters});

  factory VehicleType.fromJson(Map<String, dynamic> json) => _$VehicleTypeFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleTypeToJson(this);
}