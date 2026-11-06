// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_store_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicStoreListDto _$PublicStoreListDtoFromJson(Map<String, dynamic> json) =>
    PublicStoreListDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => PublicStoreSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PublicStoreListDtoToJson(PublicStoreListDto instance) =>
    <String, dynamic>{'items': instance.items, 'meta': instance.meta};
