// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_product_dto.g.dart';

@JsonSerializable()
class UpdateProductDto {
  const UpdateProductDto({
    this.title,
    this.description,
    this.regularPrice,
    this.isArchived,
  });
  
  factory UpdateProductDto.fromJson(Map<String, Object?> json) => _$UpdateProductDtoFromJson(json);
  
  final String? title;
  final String? description;

  /// Normal price in LD.
  final String? regularPrice;

  /// Archived products are hidden from the list but keep their history.
  final bool? isArchived;

  Map<String, Object?> toJson() => _$UpdateProductDtoToJson(this);
}
