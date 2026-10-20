// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'claim_stats_dto.dart';
import 'offer_stats_dto.dart';
import 'store_stats_dto.dart';
import 'user_stats_dto.dart';

part 'admin_stats_dto.g.dart';

@JsonSerializable()
class AdminStatsDto {
  const AdminStatsDto({
    required this.stores,
    required this.users,
    required this.offers,
    required this.claims,
  });
  
  factory AdminStatsDto.fromJson(Map<String, Object?> json) => _$AdminStatsDtoFromJson(json);
  
  final StoreStatsDto stores;
  final UserStatsDto users;
  final OfferStatsDto offers;
  final ClaimStatsDto claims;

  Map<String, Object?> toJson() => _$AdminStatsDtoToJson(this);
}
