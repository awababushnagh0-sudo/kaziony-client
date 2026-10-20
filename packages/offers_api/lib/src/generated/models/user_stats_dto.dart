// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'user_stats_dto.g.dart';

@JsonSerializable()
class UserStatsDto {
  const UserStatsDto({
    required this.customers,
    required this.merchants,
    required this.newCustomersLast7Days,
  });
  
  factory UserStatsDto.fromJson(Map<String, Object?> json) => _$UserStatsDtoFromJson(json);
  
  final num customers;
  final num merchants;

  /// Customers who signed up in the last 7 days.
  final num newCustomersLast7Days;

  Map<String, Object?> toJson() => _$UserStatsDtoToJson(this);
}
