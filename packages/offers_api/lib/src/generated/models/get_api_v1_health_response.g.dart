// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_api_v1_health_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetApiV1HealthResponse _$GetApiV1HealthResponseFromJson(
  Map<String, dynamic> json,
) => GetApiV1HealthResponse(
  status: json['status'] == null
      ? null
      : Status.fromJson(json['status'] as String),
  info: (json['info'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, Info.fromJson(e as Map<String, dynamic>)),
  ),
  error: (json['error'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, Error.fromJson(e as Map<String, dynamic>)),
  ),
  details: (json['details'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, Details.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$GetApiV1HealthResponseToJson(
  GetApiV1HealthResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'info': instance.info,
  'error': instance.error,
  'details': instance.details,
};
