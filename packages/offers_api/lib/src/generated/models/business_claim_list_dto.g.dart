// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_claim_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessClaimListDto _$BusinessClaimListDtoFromJson(
  Map<String, dynamic> json,
) => BusinessClaimListDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => BusinessClaimDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BusinessClaimListDtoToJson(
  BusinessClaimListDto instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};
