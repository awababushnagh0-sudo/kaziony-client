// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'category_dto.dart';

part 'followed_store_dto.g.dart';

@JsonSerializable()
class FollowedStoreDto {
  const FollowedStoreDto({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.category,
    required this.liveOfferCount,
    required this.followedAt,
  });
  
  factory FollowedStoreDto.fromJson(Map<String, Object?> json) => _$FollowedStoreDtoFromJson(json);
  
  final String id;
  final String name;
  final String? logoUrl;
  final CategoryDto category;
  final num liveOfferCount;
  final DateTime followedAt;

  Map<String, Object?> toJson() => _$FollowedStoreDtoToJson(this);
}
