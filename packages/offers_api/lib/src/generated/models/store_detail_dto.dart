// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'branch_dto.dart';
import 'category_dto.dart';
import 'store_member_dto.dart';

part 'store_detail_dto.g.dart';

@JsonSerializable()
class StoreDetailDto {
  const StoreDetailDto({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.coverUrl,
    required this.phone,
    required this.email,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.isActive,
    required this.createdAt,
    required this.category,
    required this.branches,
    required this.members,
  });
  
  factory StoreDetailDto.fromJson(Map<String, Object?> json) => _$StoreDetailDtoFromJson(json);
  
  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
  final String? coverUrl;
  final String? phone;
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;
  final bool isActive;
  final DateTime createdAt;
  final CategoryDto category;
  final List<BranchDto> branches;
  final List<StoreMemberDto> members;

  Map<String, Object?> toJson() => _$StoreDetailDtoToJson(this);
}
