// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreListDto _$StoreListDtoFromJson(Map<String, dynamic> json) => StoreListDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => StoreListItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StoreListDtoToJson(StoreListDto instance) =>
    <String, dynamic>{'items': instance.items, 'meta': instance.meta};
