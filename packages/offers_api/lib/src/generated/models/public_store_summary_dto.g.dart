// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_store_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicStoreSummaryDto _$PublicStoreSummaryDtoFromJson(
  Map<String, dynamic> json,
) => PublicStoreSummaryDto(
  id: json['id'] as String,
  name: json['name'] as String,
  logoUrl: json['logoUrl'] as String?,
  coverUrl: json['coverUrl'] as String?,
  category: CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
  ratingAverage: json['ratingAverage'] as num?,
  ratingCount: json['ratingCount'] as num,
  location: PublicLocationDto.fromJson(
    json['location'] as Map<String, dynamic>,
  ),
  liveOfferCount: json['liveOfferCount'] as num,
);

Map<String, dynamic> _$PublicStoreSummaryDtoToJson(
  PublicStoreSummaryDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logoUrl': ?instance.logoUrl,
  'coverUrl': ?instance.coverUrl,
  'category': instance.category,
  'ratingAverage': ?instance.ratingAverage,
  'ratingCount': instance.ratingCount,
  'location': instance.location,
  'liveOfferCount': instance.liveOfferCount,
};
