import 'package:json_annotation/json_annotation.dart';

part 'paged_list_model.g.dart';

@JsonSerializable(genericArgumentFactories: true, fieldRename: FieldRename.snake)
class PagedList<T> {
  int currentPage;
  int totalPages;
  int pageSize;
  int totalCount;
  bool hasPrevious;
  bool hasNext;
  List<T> data;

  PagedList(this.currentPage, this.totalPages, this.pageSize, this.totalCount,
      this.hasPrevious, this.hasNext, this.data);

  factory PagedList.fromJson(Map<String, dynamic> json, T Function(Object json) fromJsonT) => _$PagedListFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$PagedListToJson(this, toJsonT);
}