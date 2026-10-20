// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_claim_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerClaimListDto _$CustomerClaimListDtoFromJson(
  Map<String, dynamic> json,
) => CustomerClaimListDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => CustomerClaimDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CustomerClaimListDtoToJson(
  CustomerClaimListDto instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};
