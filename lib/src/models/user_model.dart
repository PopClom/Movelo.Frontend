import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';


@JsonSerializable()
class User {
  String email;
  String password;
  String firstName;
  String lastName;
  String phone;

  User({this.email, this.password, this.firstName, this.lastName, this.phone});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}