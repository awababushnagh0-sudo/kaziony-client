// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_category_dto.g.dart';

@JsonSerializable()
class UpdateCategoryDto {
  const UpdateCategoryDto({
    this.slug,
    this.nameAr,
    this.nameEn,
    this.iconUrl,
    this.sortOrder,
    this.isActive,
  });
  
  factory UpdateCategoryDto.fromJson(Map<String, Object?> json) => _$UpdateCategoryDtoFromJson(json);
  
  /// Lowercase, used in URLs and filters.
  final String? slug;
  final String? nameAr;
  final String? nameEn;
  final String? iconUrl;

  /// Lower numbers show first.
  final num? sortOrder;

  /// Hidden categories don't show in the apps. Categories can't be deleted.
  final bool? isActive;

  Map<String, Object?> toJson() => _$UpdateCategoryDtoToJson(this);
}
