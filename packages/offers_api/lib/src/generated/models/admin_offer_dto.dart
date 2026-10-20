// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'offer_status.dart';
import 'offer_store_dto.dart';
import 'offer_type.dart';

part 'admin_offer_dto.g.dart';

@JsonSerializable()
class AdminOfferDto {
  const AdminOfferDto({
    required this.type,
    required this.status,
    required this.id,
    required this.title,
    required this.store,
    required this.originalPrice,
    required this.offerPrice,
    required this.totalQuantity,
    required this.remainingQuantity,
    required this.claimCount,
    required this.startsAt,
    required this.endsAt,
    required this.createdAt,
  });
  
  factory AdminOfferDto.fromJson(Map<String, Object?> json) => _$AdminOfferDtoFromJson(json);
  
  final OfferType type;
  final OfferStatus status;
  final String id;
  final String title;
  final OfferStoreDto store;

  /// LD with 3 decimals, e.g. "8.000"
  final String originalPrice;

  /// LD with 3 decimals, e.g. "4.000"
  final String offerPrice;
  final num? totalQuantity;
  final num? remainingQuantity;
  final num claimCount;
  final DateTime startsAt;
  final DateTime endsAt;
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$AdminOfferDtoToJson(this);
}
