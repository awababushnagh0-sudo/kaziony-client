// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_claim_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportClaimDto _$ReportClaimDtoFromJson(Map<String, dynamic> json) =>
    ReportClaimDto(
      reason: ReportReason.fromJson(json['reason'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$ReportClaimDtoToJson(ReportClaimDto instance) =>
    <String, dynamic>{'reason': instance.reason, 'note': ?instance.note};
