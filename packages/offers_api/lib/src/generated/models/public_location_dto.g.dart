// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicLocationDto _$PublicLocationDtoFromJson(Map<String, dynamic> json) =>
    PublicLocationDto(
      city: City.fromJson(json['city'] as String),
      openingHours: json['openingHours'],
      area: json['area'] as String?,
      address: json['address'] as String?,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
      phone: json['phone'] as String?,
      distanceKm: json['distanceKm'] as num?,
    );

Map<String, dynamic> _$PublicLocationDtoToJson(PublicLocationDto instance) =>
    <String, dynamic>{
      'city': instance.city,
      'openingHours': ?instance.openingHours,
      'area': ?instance.area,
      'address': ?instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': ?instance.phone,
      'distanceKm': ?instance.distanceKm,
    };
