// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCategoryDto _$UpdateCategoryDtoFromJson(Map<String, dynamic> json) =>
    UpdateCategoryDto(
      slug: json['slug'] as String?,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
      iconUrl: json['iconUrl'] as String?,
      sortOrder: json['sortOrder'] as num?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$UpdateCategoryDtoToJson(UpdateCategoryDto instance) =>
    <String, dynamic>{
      'slug': ?instance.slug,
      'nameAr': ?instance.nameAr,
      'nameEn': ?instance.nameEn,
      'iconUrl': ?instance.iconUrl,
      'sortOrder': ?instance.sortOrder,
      'isActive': ?instance.isActive,
    };
