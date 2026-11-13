// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_claim_report_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminClaimReportListDto _$AdminClaimReportListDtoFromJson(
  Map<String, dynamic> json,
) => AdminClaimReportListDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => AdminClaimReportDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdminClaimReportListDtoToJson(
  AdminClaimReportListDto instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};
