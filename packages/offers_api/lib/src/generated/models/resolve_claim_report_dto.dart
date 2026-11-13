// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'resolve_claim_report_dto.g.dart';

@JsonSerializable()
class ResolveClaimReportDto {
  const ResolveClaimReportDto({
    this.removeStrike,
    this.endPause,
    this.resolution,
  });
  
  factory ResolveClaimReportDto.fromJson(Map<String, Object?> json) => _$ResolveClaimReportDtoFromJson(json);
  
  /// Take back the strike the booking gave: 409 with error "NoStrike" when.
  /// it gave none, or it was taken back already.
  final bool? removeStrike;

  /// End the customer's pause in booking now: 409 with error "NotPaused".
  /// when they aren't paused. Strikes before now stop counting.
  final bool? endPause;

  /// What our team found, for the team.
  final String? resolution;

  Map<String, Object?> toJson() => _$ResolveClaimReportDtoToJson(this);
}
