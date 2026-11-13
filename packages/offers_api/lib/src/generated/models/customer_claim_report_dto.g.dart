// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_claim_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerClaimReportDto _$CustomerClaimReportDtoFromJson(
  Map<String, dynamic> json,
) => CustomerClaimReportDto(
  reason: ReportReason.fromJson(json['reason'] as String),
  status: ReportStatus.fromJson(json['status'] as String),
  note: json['note'] as String?,
  strikeRemoved: json['strikeRemoved'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  resolvedAt: json['resolvedAt'] == null
      ? null
      : DateTime.parse(json['resolvedAt'] as String),
);

Map<String, dynamic> _$CustomerClaimReportDtoToJson(
  CustomerClaimReportDto instance,
) => <String, dynamic>{
  'reason': instance.reason,
  'status': instance.status,
  'note': ?instance.note,
  'strikeRemoved': instance.strikeRemoved,
  'createdAt': instance.createdAt.toIso8601String(),
  'resolvedAt': ?instance.resolvedAt?.toIso8601String(),
};
