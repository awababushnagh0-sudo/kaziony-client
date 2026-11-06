// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_store_dto.g.dart';

@JsonSerializable()
class UpdateStoreDto {
  const UpdateStoreDto({
    this.categoryId,
    this.name,
    this.pickupInstructions,
    this.phone,
    this.email,
    this.facebookUrl,
    this.instagramUrl,
    this.isActive,
  });
  
  factory UpdateStoreDto.fromJson(Map<String, Object?> json) => _$UpdateStoreDtoFromJson(json);
  
  final String? categoryId;
  final String? name;

  /// Shown to customers on every offer's page: where to go in the shop,.
  /// what to bring.
  final String? pickupInstructions;
  final String? phone;

  /// For customers to get in touch.
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;

  /// Disabled stores are hidden from customers and can't post offers.
  final bool? isActive;

  Map<String, Object?> toJson() => _$UpdateStoreDtoToJson(this);
}
