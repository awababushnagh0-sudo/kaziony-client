// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_customer_strike_claim_dto.dart';

part 'admin_customer_strike_dto.g.dart';

@JsonSerializable()
class AdminCustomerStrikeDto {
  const AdminCustomerStrikeDto({
    required this.id,
    required this.createdAt,
    required this.counts,
    required this.claim,
  });
  
  factory AdminCustomerStrikeDto.fromJson(Map<String, Object?> json) => _$AdminCustomerStrikeDtoFromJson(json);
  
  final String id;
  final DateTime createdAt;

  /// It counts toward a pause now: within 30 days and after the last pause.
  final bool counts;

  /// The booking missed; null for strikes from before they were linked.
  final AdminCustomerStrikeClaimDto? claim;

  Map<String, Object?> toJson() => _$AdminCustomerStrikeDtoToJson(this);
}
