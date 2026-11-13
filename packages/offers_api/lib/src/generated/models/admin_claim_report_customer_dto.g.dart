// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_claim_report_customer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminClaimReportCustomerDto _$AdminClaimReportCustomerDtoFromJson(
  Map<String, dynamic> json,
) => AdminClaimReportCustomerDto(
  id: json['id'] as String,
  name: json['name'] as String?,
  email: json['email'] as String?,
  contactPhone: json['contactPhone'] as String?,
  noShowCount: json['noShowCount'] as num,
  pausedUntil: json['pausedUntil'] == null
      ? null
      : DateTime.parse(json['pausedUntil'] as String),
);

Map<String, dynamic> _$AdminClaimReportCustomerDtoToJson(
  AdminClaimReportCustomerDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': ?instance.name,
  'email': ?instance.email,
  'contactPhone': ?instance.contactPhone,
  'noShowCount': instance.noShowCount,
  'pausedUntil': ?instance.pausedUntil?.toIso8601String(),
};
