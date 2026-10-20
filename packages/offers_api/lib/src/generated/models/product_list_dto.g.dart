// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListDto _$ProductListDtoFromJson(Map<String, dynamic> json) =>
    ProductListDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductListDtoToJson(ProductListDto instance) =>
    <String, dynamic>{'items': instance.items, 'meta': instance.meta};
