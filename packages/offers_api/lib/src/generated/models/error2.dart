// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'status2.dart';

part 'error2.g.dart';

@JsonSerializable()
class Error2 {
  const Error2({
    required this.status,
    this.responseTime,
  });
  
  factory Error2.fromJson(Map<String, Object?> json) => _$Error2FromJson(json);
  
  final Status2 status;

  /// Time the health indicator took to respond, in ms
  final num? responseTime;

  Map<String, Object?> toJson() => _$Error2ToJson(this);
}
