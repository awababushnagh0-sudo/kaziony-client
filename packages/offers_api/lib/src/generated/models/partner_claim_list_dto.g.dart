// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_claim_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerClaimListDto _$PartnerClaimListDtoFromJson(Map<String, dynamic> json) =>
    PartnerClaimListDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => PartnerClaimDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PartnerClaimListDtoToJson(
  PartnerClaimListDto instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};
