// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_branch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBranchDto _$UpdateBranchDtoFromJson(Map<String, dynamic> json) =>
    UpdateBranchDto(
      city: json['city'] == null ? null : City.fromJson(json['city'] as String),
      name: json['name'] as String?,
      area: json['area'] as String?,
      address: json['address'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      phone: json['phone'] as String?,
      openingHours: json['openingHours'],
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$UpdateBranchDtoToJson(UpdateBranchDto instance) =>
    <String, dynamic>{
      'city': ?instance.city,
      'name': ?instance.name,
      'area': ?instance.area,
      'address': ?instance.address,
      'latitude': ?instance.latitude,
      'longitude': ?instance.longitude,
      'phone': ?instance.phone,
      'openingHours': ?instance.openingHours,
      'isActive': ?instance.isActive,
    };
