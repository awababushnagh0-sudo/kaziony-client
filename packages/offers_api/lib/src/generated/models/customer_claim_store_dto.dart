// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'customer_claim_store_dto.g.dart';

@JsonSerializable()
class CustomerClaimStoreDto {
  const CustomerClaimStoreDto({
    required this.id,
    required this.name,
    required this.logoUrl,
  });
  
  factory CustomerClaimStoreDto.fromJson(Map<String, Object?> json) => _$CustomerClaimStoreDtoFromJson(json);
  
  final String id;
  final String name;
  final String? logoUrl;

  Map<String, Object?> toJson() => _$CustomerClaimStoreDtoToJson(this);
}
