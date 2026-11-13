// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicLocationDto _$PublicLocationDtoFromJson(Map<String, dynamic> json) =>
    PublicLocationDto(
      city: City.fromJson(json['city'] as String),
      openingHours: json['openingHours'],
      specialHours: json['specialHours'] as List<dynamic>,
      area: json['area'] as String,
      address: json['address'] as String?,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
      phone: json['phone'] as String,
      pausedUntil: json['pausedUntil'] == null
          ? null
          : DateTime.parse(json['pausedUntil'] as String),
      distanceKm: json['distanceKm'] as num?,
    );

Map<String, dynamic> _$PublicLocationDtoToJson(PublicLocationDto instance) =>
    <String, dynamic>{
      'city': instance.city,
      'openingHours': ?instance.openingHours,
      'specialHours': instance.specialHours,
      'area': instance.area,
      'address': ?instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': instance.phone,
      'pausedUntil': ?instance.pausedUntil?.toIso8601String(),
      'distanceKm': ?instance.distanceKm,
    };
