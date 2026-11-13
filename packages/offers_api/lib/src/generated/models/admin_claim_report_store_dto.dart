// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_claim_report_store_dto.g.dart';

@JsonSerializable()
class AdminClaimReportStoreDto {
  const AdminClaimReportStoreDto({
    required this.id,
    required this.name,
    required this.area,
  });
  
  factory AdminClaimReportStoreDto.fromJson(Map<String, Object?> json) => _$AdminClaimReportStoreDtoFromJson(json);
  
  final String id;
  final String name;
  final String area;

  Map<String, Object?> toJson() => _$AdminClaimReportStoreDtoToJson(this);
}
