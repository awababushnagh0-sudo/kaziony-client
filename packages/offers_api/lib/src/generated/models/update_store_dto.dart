// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'city.dart';

part 'update_store_dto.g.dart';

@JsonSerializable()
class UpdateStoreDto {
  const UpdateStoreDto({
    this.city,
    this.area,
    this.address,
    this.latitude,
    this.longitude,
    this.openingHours,
    this.categoryId,
    this.name,
    this.pickupInstructions,
    this.phone,
    this.email,
    this.facebookUrl,
    this.instagramUrl,
    this.isActive,
    this.delivers,
    this.deliveryPhone,
  });
  
  factory UpdateStoreDto.fromJson(Map<String, Object?> json) => _$UpdateStoreDtoFromJson(json);
  
  final City? city;

  /// The neighbourhood, shown with the store's name: it tells a brand's.
  /// places apart, so every store has one.
  final String? area;
  final String? address;
  final num? latitude;
  final num? longitude;

  /// Opening hours per day ("sat" to "fri"), up to 4 times a day. A close.
  /// earlier than the open is past midnight; a day left out isn't said.
  final dynamic openingHours;
  final String? categoryId;
  final String? name;

  /// Shown to customers on every offer's page: where to go in the shop,.
  /// what to bring.
  final String? pickupInstructions;

  /// How customers reach the store about a pickup: late, or can't find it.
  final String? phone;

  /// For customers to get in touch.
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;

  /// Disabled stores are hidden from customers and can't post offers.
  final bool? isActive;

  /// Has its own drivers: customers with a booking can call to have it.
  /// brought. Delivery is between them and the store, not us.
  final bool? delivers;

  /// The drivers' number customers call; empty for the store's phone.
  final String? deliveryPhone;

  Map<String, Object?> toJson() => _$UpdateStoreDtoToJson(this);
}
