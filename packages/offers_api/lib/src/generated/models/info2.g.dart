// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Info2 _$Info2FromJson(Map<String, dynamic> json) => Info2(
  status: Status2.fromJson(json['status'] as String),
  responseTime: json['responseTime'] as num?,
);

Map<String, dynamic> _$Info2ToJson(Info2 instance) => <String, dynamic>{
  'status': instance.status,
  'responseTime': ?instance.responseTime,
};
