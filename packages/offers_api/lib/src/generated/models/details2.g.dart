// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Details2 _$Details2FromJson(Map<String, dynamic> json) => Details2(
  status: Status2.fromJson(json['status'] as String),
  responseTime: json['responseTime'] as num?,
);

Map<String, dynamic> _$Details2ToJson(Details2 instance) => <String, dynamic>{
  'status': instance.status,
  'responseTime': ?instance.responseTime,
};
