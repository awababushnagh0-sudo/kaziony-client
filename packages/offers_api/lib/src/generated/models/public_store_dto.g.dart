// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicStoreDto _$PublicStoreDtoFromJson(Map<String, dynamic> json) =>
    PublicStoreDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      phone: json['phone'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      category: CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
      branches: (json['branches'] as List<dynamic>)
          .map((e) => PublicBranchDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      followerCount: json['followerCount'] as num,
      isFollowing: json['isFollowing'] as bool?,
      offers: (json['offers'] as List<dynamic>)
          .map((e) => PublicOfferDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PublicStoreDtoToJson(PublicStoreDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'logoUrl': instance.logoUrl,
      'coverUrl': instance.coverUrl,
      'phone': instance.phone,
      'facebookUrl': instance.facebookUrl,
      'instagramUrl': instance.instagramUrl,
      'category': instance.category,
      'branches': instance.branches,
      'followerCount': instance.followerCount,
      'isFollowing': instance.isFollowing,
      'offers': instance.offers,
    };
