// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'support_contact_dto.g.dart';

@JsonSerializable()
class SupportContactDto {
  const SupportContactDto({
    required this.phone,
    required this.whatsapp,
    required this.email,
    required this.hoursAr,
    required this.hoursEn,
  });
  
  factory SupportContactDto.fromJson(Map<String, Object?> json) => _$SupportContactDtoFromJson(json);
  
  /// To call.
  final String phone;

  /// For a WhatsApp chat link (wa.me): international, digits only.
  final String whatsapp;
  final String email;

  /// When the team answers, in Arabic.
  final String hoursAr;

  /// When the team answers, in English.
  final String hoursEn;

  Map<String, Object?> toJson() => _$SupportContactDtoToJson(this);
}
