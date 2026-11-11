// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_store_profile_dto.g.dart';

@JsonSerializable()
class UpdateStoreProfileDto {
  const UpdateStoreProfileDto({
    this.openingHours,
    this.pickupInstructions,
    this.phone,
    this.email,
    this.facebookUrl,
    this.instagramUrl,
  });
  
  factory UpdateStoreProfileDto.fromJson(Map<String, Object?> json) => _$UpdateStoreProfileDtoFromJson(json);
  
  /// Opening hours per day ("sat" to "fri"), up to 4 times a day. A close.
  /// earlier than the open is past midnight; a day left out isn't said.
  final dynamic openingHours;

  /// Shown to customers on every offer's page: where to go in the shop,.
  /// what to bring.
  final String? pickupInstructions;

  /// How customers reach the store about a pickup: late, or can't find it.
  final String? phone;

  /// For customers to get in touch.
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;

  Map<String, Object?> toJson() => _$UpdateStoreProfileDtoToJson(this);
}
