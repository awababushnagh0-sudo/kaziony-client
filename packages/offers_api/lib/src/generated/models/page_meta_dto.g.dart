// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_meta_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageMetaDto _$PageMetaDtoFromJson(Map<String, dynamic> json) => PageMetaDto(
  page: json['page'] as num,
  pageSize: json['pageSize'] as num,
  total: json['total'] as num,
);

Map<String, dynamic> _$PageMetaDtoToJson(PageMetaDto instance) =>
    <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
      'total': instance.total,
    };
