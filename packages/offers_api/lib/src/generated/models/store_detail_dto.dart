// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'category_dto.dart';
import 'city.dart';
import 'store_member_dto.dart';

part 'store_detail_dto.g.dart';

@JsonSerializable()
class StoreDetailDto {
  const StoreDetailDto({
    required this.city,
    required this.openingHours,
    required this.id,
    required this.name,
    required this.area,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.logoUrl,
    required this.coverUrl,
    required this.phone,
    required this.email,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.pickupInstructions,
    required this.ratingAverage,
    required this.ratingCount,
    required this.isActive,
    required this.createdAt,
    required this.category,
    required this.members,
  });
  
  factory StoreDetailDto.fromJson(Map<String, Object?> json) => _$StoreDetailDtoFromJson(json);
  
  final City city;
  final dynamic openingHours;
  final String id;
  final String name;

  /// The neighbourhood, shown with the name.
  final String? area;
  final String? address;
  final num latitude;
  final num longitude;
  final String? logoUrl;
  final String? coverUrl;
  final String? phone;
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;

  /// Shown to customers on every offer's page.
  final String? pickupInstructions;

  /// Average stars from customers' pickups, one decimal; null before the first.
  final num? ratingAverage;
  final num ratingCount;
  final bool isActive;
  final DateTime createdAt;
  final CategoryDto category;
  final List<StoreMemberDto> members;

  Map<String, Object?> toJson() => _$StoreDetailDtoToJson(this);
}
