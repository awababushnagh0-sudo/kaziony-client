// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'page_meta_dto.dart';
import 'store_list_item_dto.dart';

part 'store_list_dto.g.dart';

@JsonSerializable()
class StoreListDto {
  const StoreListDto({
    required this.items,
    required this.meta,
  });
  
  factory StoreListDto.fromJson(Map<String, Object?> json) => _$StoreListDtoFromJson(json);
  
  final List<StoreListItemDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$StoreListDtoToJson(this);
}
