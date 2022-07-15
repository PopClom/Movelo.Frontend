// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedList<T> _$PagedListFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object json) fromJsonT,
) {
  return PagedList<T>(
    json['current_page'] as int,
    json['total_pages'] as int,
    json['page_size'] as int,
    json['total_count'] as int,
    json['has_previous'] as bool,
    json['has_next'] as bool,
    (json['data'] as List)?.map(fromJsonT)?.toList(),
  );
}

Map<String, dynamic> _$PagedListToJson<T>(
  PagedList<T> instance,
  Object Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
      'page_size': instance.pageSize,
      'total_count': instance.totalCount,
      'has_previous': instance.hasPrevious,
      'has_next': instance.hasNext,
      'data': instance.data?.map(toJsonT)?.toList(),
    };
