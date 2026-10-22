// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_offer_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerOfferListDto _$PartnerOfferListDtoFromJson(Map<String, dynamic> json) =>
    PartnerOfferListDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => PartnerOfferDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PartnerOfferListDtoToJson(
  PartnerOfferListDto instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};
