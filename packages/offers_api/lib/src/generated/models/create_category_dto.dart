// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_category_dto.g.dart';

@JsonSerializable()
class CreateCategoryDto {
  const CreateCategoryDto({
    required this.slug,
    required this.nameAr,
    required this.nameEn,
    this.iconUrl,
    this.sortOrder,
  });
  
  factory CreateCategoryDto.fromJson(Map<String, Object?> json) => _$CreateCategoryDtoFromJson(json);
  
  /// Lowercase, used in URLs and filters.
  final String slug;
  final String nameAr;
  final String nameEn;
  final String? iconUrl;

  /// Lower numbers show first.
  final num? sortOrder;

  Map<String, Object?> toJson() => _$CreateCategoryDtoToJson(this);
}
