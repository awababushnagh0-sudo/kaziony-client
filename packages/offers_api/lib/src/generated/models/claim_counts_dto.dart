// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'claim_counts_dto.g.dart';

@JsonSerializable()
class ClaimCountsDto {
  const ClaimCountsDto({
    required this.reserved,
    required this.redeemed,
    required this.expired,
    required this.cancelled,
  });
  
  factory ClaimCountsDto.fromJson(Map<String, Object?> json) => _$ClaimCountsDtoFromJson(json);
  
  final num reserved;
  final num redeemed;
  final num expired;
  final num cancelled;

  Map<String, Object?> toJson() => _$ClaimCountsDtoToJson(this);
}
