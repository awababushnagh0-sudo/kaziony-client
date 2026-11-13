// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_claim_report_dto.dart';
import 'page_meta_dto.dart';

part 'admin_claim_report_list_dto.g.dart';

@JsonSerializable()
class AdminClaimReportListDto {
  const AdminClaimReportListDto({
    required this.items,
    required this.meta,
  });
  
  factory AdminClaimReportListDto.fromJson(Map<String, Object?> json) => _$AdminClaimReportListDtoFromJson(json);
  
  final List<AdminClaimReportDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$AdminClaimReportListDtoToJson(this);
}
