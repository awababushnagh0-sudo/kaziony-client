// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductDto {
  const ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.regularPrice,
    required this.imageUrl,
    required this.thumbUrl,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory ProductDto.fromJson(Map<String, Object?> json) => _$ProductDtoFromJson(json);
  
  final String id;
  final String title;
  final String? description;

  /// LD with 3 decimals, e.g. "8.000"
  final String regularPrice;
  final String? imageUrl;
  final String? thumbUrl;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$ProductDtoToJson(this);
}
