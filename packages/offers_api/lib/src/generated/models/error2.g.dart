// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Error2 _$Error2FromJson(Map<String, dynamic> json) => Error2(
  status: Status2.fromJson(json['status'] as String),
  responseTime: json['responseTime'] as num?,
);

Map<String, dynamic> _$Error2ToJson(Error2 instance) => <String, dynamic>{
  'status': instance.status,
  'responseTime': ?instance.responseTime,
};
