// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_product_dto.g.dart';

@JsonSerializable()
class CreateProductDto {
  const CreateProductDto({
    required this.title,
    required this.regularPrice,
    this.description,
  });
  
  factory CreateProductDto.fromJson(Map<String, Object?> json) => _$CreateProductDtoFromJson(json);
  
  final String title;
  final String? description;

  /// Normal price in LD.
  final String regularPrice;

  Map<String, Object?> toJson() => _$CreateProductDtoToJson(this);
}
