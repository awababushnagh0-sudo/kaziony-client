// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Details _$DetailsFromJson(Map<String, dynamic> json) => Details(
  status: Status2.fromJson(json['status'] as String),
  responseTime: json['responseTime'] as num?,
);

Map<String, dynamic> _$DetailsToJson(Details instance) => <String, dynamic>{
  'status': instance.status,
  'responseTime': ?instance.responseTime,
};
