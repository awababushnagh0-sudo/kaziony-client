// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'report_reason.dart';

part 'report_claim_dto.g.dart';

@JsonSerializable()
class ReportClaimDto {
  const ReportClaimDto({
    required this.reason,
    this.note,
  });
  
  factory ReportClaimDto.fromJson(Map<String, Object?> json) => _$ReportClaimDtoFromJson(json);
  
  final ReportReason reason;

  /// What happened, in the customer's words. Needed for OTHER: 400 with.
  /// error "NoteRequired" without it.
  final String? note;

  Map<String, Object?> toJson() => _$ReportClaimDtoToJson(this);
}
