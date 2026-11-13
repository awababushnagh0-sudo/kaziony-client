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
    required this.area,
    required this.logoUrl,
    required this.deliveryPhone,
  });
  
  factory CustomerClaimStoreDto.fromJson(Map<String, Object?> json) => _$CustomerClaimStoreDtoFromJson(json);
  
  final String id;
  final String name;

  /// The neighbourhood, shown with the name.
  final String area;
  final String? logoUrl;

  /// Set when the store delivers with its own drivers, or this booking is.
  /// already on its way with one: the number to call to have it brought, or.
  /// about it. Delivery and any fee are between the customer and the store.
  final String? deliveryPhone;

  Map<String, Object?> toJson() => _$CustomerClaimStoreDtoToJson(this);
}
