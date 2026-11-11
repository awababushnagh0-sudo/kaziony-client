// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'city.dart';
import 'new_merchant_dto.dart';

part 'create_store_dto.g.dart';

@JsonSerializable()
class CreateStoreDto {
  const CreateStoreDto({
    required this.city,
    required this.categoryId,
    required this.name,
    required this.owner,
    required this.area,
    required this.latitude,
    required this.longitude,
    this.pickupInstructions,
    this.phone,
    this.email,
    this.facebookUrl,
    this.instagramUrl,
    this.address,
    this.openingHours,
  });
  
  factory CreateStoreDto.fromJson(Map<String, Object?> json) => _$CreateStoreDtoFromJson(json);
  
  final City city;
  final String categoryId;
  final String name;

  /// Shown to customers on every offer's page: where to go in the shop,.
  /// what to bring.
  final String? pickupInstructions;
  final String? phone;

  /// For customers to get in touch.
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;

  /// The store owner's account.
  final NewMerchantDto owner;

  /// The neighbourhood, shown with the store's name: it tells a brand's.
  /// places apart, so every store has one.
  final String area;
  final String? address;
  final num latitude;
  final num longitude;

  /// Opening hours per day ("sat" to "fri"), up to 4 times a day. A close.
  /// earlier than the open is past midnight; a day left out isn't said.
  final dynamic openingHours;

  Map<String, Object?> toJson() => _$CreateStoreDtoToJson(this);
}
