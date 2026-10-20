// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'page_meta_dto.dart';
import 'product_dto.dart';

part 'product_list_dto.g.dart';

@JsonSerializable()
class ProductListDto {
  const ProductListDto({
    required this.items,
    required this.meta,
  });
  
  factory ProductListDto.fromJson(Map<String, Object?> json) => _$ProductListDtoFromJson(json);
  
  final List<ProductDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$ProductListDtoToJson(this);
}
