// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'rate_claim_dto.g.dart';

@JsonSerializable()
class RateClaimDto {
  const RateClaimDto({
    required this.stars,
  });
  
  factory RateClaimDto.fromJson(Map<String, Object?> json) => _$RateClaimDtoFromJson(json);
  
  final num stars;

  Map<String, Object?> toJson() => _$RateClaimDtoToJson(this);
}
