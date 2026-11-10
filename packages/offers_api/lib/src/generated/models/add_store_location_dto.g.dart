// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_store_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddStoreLocationDto _$AddStoreLocationDtoFromJson(Map<String, dynamic> json) =>
    AddStoreLocationDto(
      city: City.fromJson(json['city'] as String),
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
      phone: json['phone'] as String?,
      area: json['area'] as String?,
      address: json['address'] as String?,
      openingHours: json['openingHours'],
    );

Map<String, dynamic> _$AddStoreLocationDtoToJson(
  AddStoreLocationDto instance,
) => <String, dynamic>{
  'city': instance.city,
  'phone': ?instance.phone,
  'area': ?instance.area,
  'address': ?instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'openingHours': ?instance.openingHours,
};
