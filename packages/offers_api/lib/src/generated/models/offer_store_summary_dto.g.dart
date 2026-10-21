// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_store_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferStoreSummaryDto _$OfferStoreSummaryDtoFromJson(
  Map<String, dynamic> json,
) => OfferStoreSummaryDto(
  id: json['id'] as String,
  name: json['name'] as String,
  logoUrl: json['logoUrl'] as String?,
  category: CategoryDto.fromJson(json['category'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OfferStoreSummaryDtoToJson(
  OfferStoreSummaryDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logoUrl': ?instance.logoUrl,
  'category': instance.category,
};
