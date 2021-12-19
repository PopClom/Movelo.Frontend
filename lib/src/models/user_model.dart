import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';


@JsonSerializable()
class User {
  int id;
  String email;
  String password;
  String firstName;
  String lastName;
  String phone;
  String profileType;

  User({
    this.id,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.phone,
    this.profileType
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}