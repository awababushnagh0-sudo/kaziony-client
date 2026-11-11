// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_list_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreListItemDto _$StoreListItemDtoFromJson(Map<String, dynamic> json) =>
    StoreListItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      area: json['area'] as String,
      logoUrl: json['logoUrl'] as String?,
      isActive: json['isActive'] as bool,
      category: CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$StoreListItemDtoToJson(StoreListItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'area': instance.area,
      'logoUrl': ?instance.logoUrl,
      'isActive': instance.isActive,
      'category': instance.category,
      'createdAt': instance.createdAt.toIso8601String(),
    };
