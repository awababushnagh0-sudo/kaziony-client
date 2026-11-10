// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'status.dart';
import 'info2.dart';
import 'error2.dart';
import 'details2.dart';

part 'get_api_v1_health_ready_response.g.dart';

@JsonSerializable()
class GetApiV1HealthReadyResponse {
  const GetApiV1HealthReadyResponse({
    this.status,
    this.info,
    this.error,
    this.details,
  });
  
  factory GetApiV1HealthReadyResponse.fromJson(Map<String, Object?> json) => _$GetApiV1HealthReadyResponseFromJson(json);
  
  final Status? status;
  final Map<String, Info2>? info;
  final Map<String, Error2>? error;
  final Map<String, Details2>? details;

  Map<String, Object?> toJson() => _$GetApiV1HealthReadyResponseToJson(this);
}
