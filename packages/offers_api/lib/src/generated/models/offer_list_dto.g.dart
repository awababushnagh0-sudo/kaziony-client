// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferListDto _$OfferListDtoFromJson(Map<String, dynamic> json) => OfferListDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => AdminOfferDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OfferListDtoToJson(OfferListDto instance) =>
    <String, dynamic>{'items': instance.items, 'meta': instance.meta};
