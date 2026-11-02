// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_service_area_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateServiceAreaDto _$UpdateServiceAreaDtoFromJson(
  Map<String, dynamic> json,
) => UpdateServiceAreaDto(
  nameAr: json['nameAr'] as String?,
  nameEn: json['nameEn'] as String?,
  latitude: json['latitude'] as num?,
  longitude: json['longitude'] as num?,
  radiusKm: json['radiusKm'] as num?,
  isActive: json['isActive'] as bool?,
);

Map<String, dynamic> _$UpdateServiceAreaDtoToJson(
  UpdateServiceAreaDto instance,
) => <String, dynamic>{
  'nameAr': ?instance.nameAr,
  'nameEn': ?instance.nameEn,
  'latitude': ?instance.latitude,
  'longitude': ?instance.longitude,
  'radiusKm': ?instance.radiusKm,
  'isActive': ?instance.isActive,
};
