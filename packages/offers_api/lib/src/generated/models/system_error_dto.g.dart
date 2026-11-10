// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_error_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemErrorDto _$SystemErrorDtoFromJson(Map<String, dynamic> json) =>
    SystemErrorDto(
      fingerprint: json['fingerprint'] as String,
      name: json['name'] as String,
      message: json['message'] as String,
      method: json['method'] as String,
      route: json['route'] as String,
      statusCode: json['statusCode'] as num,
      count: json['count'] as num,
      firstSeenAt: DateTime.parse(json['firstSeenAt'] as String),
      lastSeenAt: DateTime.parse(json['lastSeenAt'] as String),
      lastRequestId: json['lastRequestId'] as String?,
      stack: json['stack'] as String?,
      instanceCount: json['instanceCount'] as num,
    );

Map<String, dynamic> _$SystemErrorDtoToJson(SystemErrorDto instance) =>
    <String, dynamic>{
      'fingerprint': instance.fingerprint,
      'name': instance.name,
      'message': instance.message,
      'method': instance.method,
      'route': instance.route,
      'statusCode': instance.statusCode,
      'count': instance.count,
      'firstSeenAt': instance.firstSeenAt.toIso8601String(),
      'lastSeenAt': instance.lastSeenAt.toIso8601String(),
      'lastRequestId': ?instance.lastRequestId,
      'stack': ?instance.stack,
      'instanceCount': instance.instanceCount,
    };
