// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateStoreDto _$UpdateStoreDtoFromJson(Map<String, dynamic> json) =>
    UpdateStoreDto(
      city: json['city'] == null ? null : City.fromJson(json['city'] as String),
      area: json['area'] as String?,
      address: json['address'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      openingHours: json['openingHours'],
      categoryId: json['categoryId'] as String?,
      name: json['name'] as String?,
      pickupInstructions: json['pickupInstructions'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      facebookUrl: json['facebookUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      isActive: json['isActive'] as bool?,
      delivers: json['delivers'] as bool?,
      deliveryPhone: json['deliveryPhone'] as String?,
    );

Map<String, dynamic> _$UpdateStoreDtoToJson(UpdateStoreDto instance) =>
    <String, dynamic>{
      'city': ?instance.city,
      'area': ?instance.area,
      'address': ?instance.address,
      'latitude': ?instance.latitude,
      'longitude': ?instance.longitude,
      'openingHours': ?instance.openingHours,
      'categoryId': ?instance.categoryId,
      'name': ?instance.name,
      'pickupInstructions': ?instance.pickupInstructions,
      'phone': ?instance.phone,
      'email': ?instance.email,
      'facebookUrl': ?instance.facebookUrl,
      'instagramUrl': ?instance.instagramUrl,
      'isActive': ?instance.isActive,
      'delivers': ?instance.delivers,
      'deliveryPhone': ?instance.deliveryPhone,
    };
