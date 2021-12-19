// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'travel_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TravelList _$TravelListFromJson(Map<String, dynamic> json) {
  return TravelList(
    currentPage: json['currentPage'] as int,
    totalPages: json['totalPages'] as int,
    pageSize: json['pageSize'] as int,
    totalCount: json['totalCount'] as int,
    hasPrevious: json['hasPrevious'] as bool,
    hasNext: json['hasNext'] as bool,
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Travel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TravelListToJson(TravelList instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'hasPrevious': instance.hasPrevious,
      'hasNext': instance.hasNext,
      'data': instance.data,
    };
