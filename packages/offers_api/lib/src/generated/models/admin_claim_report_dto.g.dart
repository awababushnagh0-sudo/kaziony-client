// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_claim_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminClaimReportDto _$AdminClaimReportDtoFromJson(Map<String, dynamic> json) =>
    AdminClaimReportDto(
      reason: ReportReason.fromJson(json['reason'] as String),
      status: ReportStatus.fromJson(json['status'] as String),
      id: json['id'] as String,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      claim: AdminClaimReportClaimDto.fromJson(
        json['claim'] as Map<String, dynamic>,
      ),
      store: AdminClaimReportStoreDto.fromJson(
        json['store'] as Map<String, dynamic>,
      ),
      customer: AdminClaimReportCustomerDto.fromJson(
        json['customer'] as Map<String, dynamic>,
      ),
      hasStrike: json['hasStrike'] as bool,
      strikeRemoved: json['strikeRemoved'] as bool,
      pauseEnded: json['pauseEnded'] as bool,
      resolution: json['resolution'] as String?,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      resolvedBy: json['resolvedBy'] == null
          ? null
          : AdminClaimReportResolverDto.fromJson(
              json['resolvedBy'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AdminClaimReportDtoToJson(
  AdminClaimReportDto instance,
) => <String, dynamic>{
  'reason': instance.reason,
  'status': instance.status,
  'id': instance.id,
  'note': ?instance.note,
  'createdAt': instance.createdAt.toIso8601String(),
  'claim': instance.claim,
  'store': instance.store,
  'customer': instance.customer,
  'hasStrike': instance.hasStrike,
  'strikeRemoved': instance.strikeRemoved,
  'pauseEnded': instance.pauseEnded,
  'resolution': ?instance.resolution,
  'resolvedAt': ?instance.resolvedAt?.toIso8601String(),
  'resolvedBy': ?instance.resolvedBy,
};
