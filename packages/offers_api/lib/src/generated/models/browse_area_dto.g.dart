// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_area_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrowseAreaDto _$BrowseAreaDtoFromJson(Map<String, dynamic> json) =>
    BrowseAreaDto(
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
      radiusKm: json['radiusKm'] as num,
    );

Map<String, dynamic> _$BrowseAreaDtoToJson(BrowseAreaDto instance) =>
    <String, dynamic>{
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radiusKm': instance.radiusKm,
    };
