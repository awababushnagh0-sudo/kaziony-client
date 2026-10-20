// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => CategoryDto(
  id: json['id'] as String,
  slug: json['slug'] as String,
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
  iconUrl: json['iconUrl'] as String?,
  sortOrder: json['sortOrder'] as num,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$CategoryDtoToJson(CategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'iconUrl': instance.iconUrl,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
    };
