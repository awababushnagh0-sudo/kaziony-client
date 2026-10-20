// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateStoreDto _$CreateStoreDtoFromJson(Map<String, dynamic> json) =>
    CreateStoreDto(
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      branches: (json['branches'] as List<dynamic>)
          .map((e) => CreateBranchDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      owner: NewMerchantDto.fromJson(json['owner'] as Map<String, dynamic>),
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
    );

Map<String, dynamic> _$CreateStoreDtoToJson(CreateStoreDto instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'phone': instance.phone,
      'facebookUrl': instance.facebookUrl,
      'instagramUrl': instance.instagramUrl,
      'branches': instance.branches,
      'owner': instance.owner,
    };
