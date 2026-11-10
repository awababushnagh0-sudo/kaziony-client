// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_v1_health_ready_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetApiV1HealthReadyResponse _$GetApiV1HealthReadyResponseFromJson(
  Map<String, dynamic> json,
) => GetApiV1HealthReadyResponse(
  status: json['status'] == null
      ? null
      : Status.fromJson(json['status'] as String),
  info: (json['info'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, Info2.fromJson(e as Map<String, dynamic>)),
  ),
  error: (json['error'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, Error2.fromJson(e as Map<String, dynamic>)),
  ),
  details: (json['details'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, Details2.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$GetApiV1HealthReadyResponseToJson(
  GetApiV1HealthReadyResponse instance,
) => <String, dynamic>{
  'status': ?instance.status,
  'info': ?instance.info,
  'error': ?instance.error,
  'details': ?instance.details,
};
