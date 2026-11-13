// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolve_claim_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolveClaimReportDto _$ResolveClaimReportDtoFromJson(
  Map<String, dynamic> json,
) => ResolveClaimReportDto(
  removeStrike: json['removeStrike'] as bool?,
  endPause: json['endPause'] as bool?,
  resolution: json['resolution'] as String?,
);

Map<String, dynamic> _$ResolveClaimReportDtoToJson(
  ResolveClaimReportDto instance,
) => <String, dynamic>{
  'removeStrike': ?instance.removeStrike,
  'endPause': ?instance.endPause,
  'resolution': ?instance.resolution,
};
