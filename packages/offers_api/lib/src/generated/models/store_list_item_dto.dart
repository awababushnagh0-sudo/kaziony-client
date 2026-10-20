// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'category_dto.dart';

part 'store_list_item_dto.g.dart';

@JsonSerializable()
class StoreListItemDto {
  const StoreListItemDto({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.isActive,
    required this.category,
    required this.branchCount,
    required this.createdAt,
  });
  
  factory StoreListItemDto.fromJson(Map<String, Object?> json) => _$StoreListItemDtoFromJson(json);
  
  final String id;
  final String name;
  final String? logoUrl;
  final bool isActive;
  final CategoryDto category;
  final num branchCount;
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$StoreListItemDtoToJson(this);
}
