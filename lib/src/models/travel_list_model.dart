import 'package:fletes_31_app/src/models/travel_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'travel_list_model.g.dart';


@JsonSerializable()
class TravelList {
  int currentPage;
  int totalPages;
  int pageSize;
  int totalCount;
  bool hasPrevious;
  bool hasNext;
  List<Travel> data;

  TravelList({
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalCount,
    this.hasPrevious,
    this.hasNext,
    this.data
  });

  factory TravelList.fromJson(Map<String, dynamic> json) => _$TravelListFromJson(json);
  Map<String, dynamic> toJson() => _$TravelListToJson(this);
}