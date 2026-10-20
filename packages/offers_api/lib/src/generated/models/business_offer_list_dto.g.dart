// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_offer_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessOfferListDto _$BusinessOfferListDtoFromJson(
  Map<String, dynamic> json,
) => BusinessOfferListDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => BusinessOfferDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BusinessOfferListDtoToJson(
  BusinessOfferListDto instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};
