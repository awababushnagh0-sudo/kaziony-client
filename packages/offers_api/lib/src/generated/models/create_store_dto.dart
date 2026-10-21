// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'create_branch_dto.dart';
import 'new_merchant_dto.dart';

part 'create_store_dto.g.dart';

@JsonSerializable()
class CreateStoreDto {
  const CreateStoreDto({
    required this.categoryId,
    required this.name,
    required this.branches,
    required this.owner,
    this.description,
    this.phone,
    this.email,
    this.facebookUrl,
    this.instagramUrl,
  });
  
  factory CreateStoreDto.fromJson(Map<String, Object?> json) => _$CreateStoreDtoFromJson(json);
  
  final String categoryId;
  final String name;
  final String? description;
  final String? phone;

  /// For customers to get in touch.
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;
  final List<CreateBranchDto> branches;

  /// The store owner's account.
  final NewMerchantDto owner;

  Map<String, Object?> toJson() => _$CreateStoreDtoToJson(this);
}
