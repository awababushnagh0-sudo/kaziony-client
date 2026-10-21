// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_branch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicBranchDto _$PublicBranchDtoFromJson(Map<String, dynamic> json) =>
    PublicBranchDto(
      city: City.fromJson(json['city'] as String),
      openingHours: json['openingHours'],
      id: json['id'] as String,
      name: json['name'] as String,
      area: json['area'] as String?,
      address: json['address'] as String?,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
      phone: json['phone'] as String?,
      distanceKm: json['distanceKm'] as num?,
    );

Map<String, dynamic> _$PublicBranchDtoToJson(PublicBranchDto instance) =>
    <String, dynamic>{
      'city': instance.city,
      'openingHours': ?instance.openingHours,
      'id': instance.id,
      'name': instance.name,
      'area': ?instance.area,
      'address': ?instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': ?instance.phone,
      'distanceKm': ?instance.distanceKm,
    };
