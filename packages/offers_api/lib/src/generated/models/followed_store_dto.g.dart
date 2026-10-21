// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'followed_store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowedStoreDto _$FollowedStoreDtoFromJson(Map<String, dynamic> json) =>
    FollowedStoreDto(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
      category: CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
      liveOfferCount: json['liveOfferCount'] as num,
      followedAt: DateTime.parse(json['followedAt'] as String),
    );

Map<String, dynamic> _$FollowedStoreDtoToJson(FollowedStoreDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logoUrl': ?instance.logoUrl,
      'category': instance.category,
      'liveOfferCount': instance.liveOfferCount,
      'followedAt': instance.followedAt.toIso8601String(),
    };
