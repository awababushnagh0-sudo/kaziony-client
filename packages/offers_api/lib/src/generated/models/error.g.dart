// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Error _$ErrorFromJson(Map<String, dynamic> json) => Error(
  status: Status2.fromJson(json['status'] as String),
  responseTime: json['responseTime'] as num?,
);

Map<String, dynamic> _$ErrorToJson(Error instance) => <String, dynamic>{
  'status': instance.status,
  'responseTime': instance.responseTime,
};
