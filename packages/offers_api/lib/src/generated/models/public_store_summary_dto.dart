// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'category_dto.dart';
import 'public_location_dto.dart';

part 'public_store_summary_dto.g.dart';

@JsonSerializable()
class PublicStoreSummaryDto {
  const PublicStoreSummaryDto({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.coverUrl,
    required this.category,
    required this.ratingAverage,
    required this.ratingCount,
    required this.location,
    required this.liveOfferCount,
  });
  
  factory PublicStoreSummaryDto.fromJson(Map<String, Object?> json) => _$PublicStoreSummaryDtoFromJson(json);
  
  final String id;
  final String name;
  final String? logoUrl;
  final String? coverUrl;
  final CategoryDto category;

  /// Average stars from customers' pickups, one decimal; null before the first.
  final num? ratingAverage;
  final num ratingCount;
  final PublicLocationDto location;
  final num liveOfferCount;

  Map<String, Object?> toJson() => _$PublicStoreSummaryDtoToJson(this);
}
