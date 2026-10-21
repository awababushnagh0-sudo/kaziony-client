// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
  status: Status2.fromJson(json['status'] as String),
  responseTime: json['responseTime'] as num?,
);

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
  'status': instance.status,
  'responseTime': ?instance.responseTime,
};
