import 'package:json_annotation/json_annotation.dart';

part 'check_email_model.g.dart';

@JsonSerializable()
class CheckEmail {
  bool available;

  CheckEmail({this.available});

  factory CheckEmail.fromJson(Map<String, dynamic> json) => _$CheckEmailFromJson(json);
  Map<String, dynamic> toJson() => _$CheckEmailToJson(this);
}
