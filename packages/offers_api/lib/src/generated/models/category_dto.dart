// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'category_dto.g.dart';

@JsonSerializable()
class CategoryDto {
  const CategoryDto({
    required this.id,
    required this.slug,
    required this.nameAr,
    required this.nameEn,
    required this.iconUrl,
    required this.sortOrder,
    required this.isActive,
  });
  
  factory CategoryDto.fromJson(Map<String, Object?> json) => _$CategoryDtoFromJson(json);
  
  final String id;
  final String slug;
  final String nameAr;
  final String nameEn;
  final String? iconUrl;
  final num sortOrder;
  final bool isActive;

  Map<String, Object?> toJson() => _$CategoryDtoToJson(this);
}
