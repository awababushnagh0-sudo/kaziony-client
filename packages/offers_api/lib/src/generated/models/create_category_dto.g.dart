// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCategoryDto _$CreateCategoryDtoFromJson(Map<String, dynamic> json) =>
    CreateCategoryDto(
      slug: json['slug'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      iconUrl: json['iconUrl'] as String?,
      sortOrder: json['sortOrder'] as num?,
    );

Map<String, dynamic> _$CreateCategoryDtoToJson(CreateCategoryDto instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'iconUrl': instance.iconUrl,
      'sortOrder': instance.sortOrder,
    };
