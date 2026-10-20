// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'category_dto.dart';
import 'public_branch_dto.dart';
import 'public_offer_dto.dart';

part 'public_store_dto.g.dart';

@JsonSerializable()
class PublicStoreDto {
  const PublicStoreDto({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.coverUrl,
    required this.phone,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.category,
    required this.branches,
    required this.followerCount,
    required this.isFollowing,
    required this.offers,
  });
  
  factory PublicStoreDto.fromJson(Map<String, Object?> json) => _$PublicStoreDtoFromJson(json);
  
  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
  final String? coverUrl;
  final String? phone;
  final String? facebookUrl;
  final String? instagramUrl;
  final CategoryDto category;

  /// Active branches, closest first when a location is sent.
  final List<PublicBranchDto> branches;
  final num followerCount;

  /// Null when not logged in as a customer.
  final bool? isFollowing;

  /// Offers live right now, ending soonest first.
  final List<PublicOfferDto> offers;

  Map<String, Object?> toJson() => _$PublicStoreDtoToJson(this);
}
