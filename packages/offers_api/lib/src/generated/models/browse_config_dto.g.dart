// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrowseConfigDto _$BrowseConfigDtoFromJson(Map<String, dynamic> json) =>
    BrowseConfigDto(
      radiusKm: json['radiusKm'] as num,
      areas: (json['areas'] as List<dynamic>)
          .map((e) => BrowseAreaDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BrowseConfigDtoToJson(BrowseConfigDto instance) =>
    <String, dynamic>{'radiusKm': instance.radiusKm, 'areas': instance.areas};
