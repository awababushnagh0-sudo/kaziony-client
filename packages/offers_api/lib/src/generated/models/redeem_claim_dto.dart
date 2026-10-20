// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'redeem_claim_dto.g.dart';

@JsonSerializable()
class RedeemClaimDto {
  const RedeemClaimDto({
    required this.code,
    this.branchId,
  });
  
  factory RedeemClaimDto.fromJson(Map<String, Object?> json) => _$RedeemClaimDtoFromJson(json);
  
  /// The code from the customer's QR code (or typed in).
  final String code;

  /// The branch where it's redeemed. Not needed for staff limited to one.
  /// branch, or when the offer is valid at only one branch.
  final String? branchId;

  Map<String, Object?> toJson() => _$RedeemClaimDtoToJson(this);
}
