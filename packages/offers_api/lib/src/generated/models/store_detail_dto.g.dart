// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreDetailDto _$StoreDetailDtoFromJson(Map<String, dynamic> json) =>
    StoreDetailDto(
      city: City.fromJson(json['city'] as String),
      openingHours: json['openingHours'],
      missingToGoLive: (json['missingToGoLive'] as List<dynamic>)
          .map((e) => GoLiveItem.fromJson(e as String))
          .toList(),
      id: json['id'] as String,
      name: json['name'] as String,
      area: json['area'] as String,
      address: json['address'] as String?,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
      logoUrl: json['logoUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      pickupInstructions: json['pickupInstructions'] as String?,
      ratingAverage: json['ratingAverage'] as num?,
      ratingCount: json['ratingCount'] as num,
      isActive: json['isActive'] as bool,
      wasLive: json['wasLive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      category: CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
      members: (json['members'] as List<dynamic>)
          .map((e) => StoreMemberDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreDetailDtoToJson(StoreDetailDto instance) =>
    <String, dynamic>{
      'city': instance.city,
      'openingHours': ?instance.openingHours,
      'missingToGoLive': instance.missingToGoLive,
      'id': instance.id,
      'name': instance.name,
      'area': instance.area,
      'address': ?instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'logoUrl': ?instance.logoUrl,
      'coverUrl': ?instance.coverUrl,
      'phone': instance.phone,
      'email': ?instance.email,
      'facebookUrl': ?instance.facebookUrl,
      'instagramUrl': ?instance.instagramUrl,
      'pickupInstructions': ?instance.pickupInstructions,
      'ratingAverage': ?instance.ratingAverage,
      'ratingCount': instance.ratingCount,
      'isActive': instance.isActive,
      'wasLive': instance.wasLive,
      'createdAt': instance.createdAt.toIso8601String(),
      'category': instance.category,
      'members': instance.members,
    };
