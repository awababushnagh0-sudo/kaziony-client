// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateStoreDto _$CreateStoreDtoFromJson(Map<String, dynamic> json) =>
    CreateStoreDto(
      city: City.fromJson(json['city'] as String),
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      owner: NewMerchantDto.fromJson(json['owner'] as Map<String, dynamic>),
      area: json['area'] as String,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
      pickupInstructions: json['pickupInstructions'] as String?,
      email: json['email'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      address: json['address'] as String?,
      openingHours: json['openingHours'],
    );

Map<String, dynamic> _$CreateStoreDtoToJson(CreateStoreDto instance) =>
    <String, dynamic>{
      'city': instance.city,
      'categoryId': instance.categoryId,
      'name': instance.name,
      'pickupInstructions': ?instance.pickupInstructions,
      'phone': instance.phone,
      'email': ?instance.email,
      'facebookUrl': ?instance.facebookUrl,
      'instagramUrl': ?instance.instagramUrl,
      'owner': instance.owner,
      'area': instance.area,
      'address': ?instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'openingHours': ?instance.openingHours,
    };
