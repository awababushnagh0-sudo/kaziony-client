// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_branch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBranchDto _$CreateBranchDtoFromJson(Map<String, dynamic> json) =>
    CreateBranchDto(
      city: City.fromJson(json['city'] as String),
      name: json['name'] as String,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
      area: json['area'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      openingHours: json['openingHours'],
    );

Map<String, dynamic> _$CreateBranchDtoToJson(CreateBranchDto instance) =>
    <String, dynamic>{
      'city': instance.city,
      'name': instance.name,
      'area': ?instance.area,
      'address': ?instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': ?instance.phone,
      'openingHours': ?instance.openingHours,
    };
