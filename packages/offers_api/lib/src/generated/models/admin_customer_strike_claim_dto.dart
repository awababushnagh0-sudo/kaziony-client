// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_customer_strike_claim_dto.g.dart';

@JsonSerializable()
class AdminCustomerStrikeClaimDto {
  const AdminCustomerStrikeClaimDto({
    required this.id,
    required this.code,
    required this.offerTitle,
    required this.storeName,
    required this.storeArea,
  });
  
  factory AdminCustomerStrikeClaimDto.fromJson(Map<String, Object?> json) => _$AdminCustomerStrikeClaimDtoFromJson(json);
  
  final String id;
  final String code;
  final String offerTitle;
  final String storeName;
  final String storeArea;

  Map<String, Object?> toJson() => _$AdminCustomerStrikeClaimDtoToJson(this);
}
