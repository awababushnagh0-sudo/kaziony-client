// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_branch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicBranchDto _$PublicBranchDtoFromJson(Map<String, dynamic> json) =>
    PublicBranchDto(
      openingHours: json['openingHours'],
      id: json['id'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      area: json['area'] as String?,
      address: json['address'] as String?,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
      phone: json['phone'] as String?,
      distanceKm: json['distanceKm'] as num?,
    );

Map<String, dynamic> _$PublicBranchDtoToJson(PublicBranchDto instance) =>
    <String, dynamic>{
      'openingHours': instance.openingHours,
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'area': instance.area,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': instance.phone,
      'distanceKm': instance.distanceKm,
    };
