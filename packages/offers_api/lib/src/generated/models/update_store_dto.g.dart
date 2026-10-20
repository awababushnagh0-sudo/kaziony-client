// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateStoreDto _$UpdateStoreDtoFromJson(Map<String, dynamic> json) =>
    UpdateStoreDto(
      categoryId: json['categoryId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$UpdateStoreDtoToJson(UpdateStoreDto instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'phone': instance.phone,
      'facebookUrl': instance.facebookUrl,
      'instagramUrl': instance.instagramUrl,
      'isActive': instance.isActive,
    };
