// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreDetailDto _$StoreDetailDtoFromJson(Map<String, dynamic> json) =>
    StoreDetailDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      phone: json['phone'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      category: CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
      branches: (json['branches'] as List<dynamic>)
          .map((e) => BranchDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      members: (json['members'] as List<dynamic>)
          .map((e) => StoreMemberDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreDetailDtoToJson(StoreDetailDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'logoUrl': instance.logoUrl,
      'coverUrl': instance.coverUrl,
      'phone': instance.phone,
      'facebookUrl': instance.facebookUrl,
      'instagramUrl': instance.instagramUrl,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'category': instance.category,
      'branches': instance.branches,
      'members': instance.members,
    };
