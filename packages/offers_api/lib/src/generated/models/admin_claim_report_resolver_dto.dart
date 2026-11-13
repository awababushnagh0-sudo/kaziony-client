// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_claim_report_resolver_dto.g.dart';

@JsonSerializable()
class AdminClaimReportResolverDto {
  const AdminClaimReportResolverDto({
    required this.id,
    required this.name,
  });
  
  factory AdminClaimReportResolverDto.fromJson(Map<String, Object?> json) => _$AdminClaimReportResolverDtoFromJson(json);
  
  final String id;
  final String? name;

  Map<String, Object?> toJson() => _$AdminClaimReportResolverDtoToJson(this);
}
