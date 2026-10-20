// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_offer_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicOfferListDto _$PublicOfferListDtoFromJson(Map<String, dynamic> json) =>
    PublicOfferListDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => PublicOfferDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PublicOfferListDtoToJson(PublicOfferListDto instance) =>
    <String, dynamic>{'items': instance.items, 'meta': instance.meta};
