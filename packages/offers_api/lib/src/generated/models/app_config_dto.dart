// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'app_version_dto.dart';
import 'browse_config_dto.dart';
import 'support_contact_dto.dart';

part 'app_config_dto.g.dart';

@JsonSerializable()
class AppConfigDto {
  const AppConfigDto({
    required this.partner,
    required this.customer,
    required this.admin,
    required this.support,
    required this.browse,
  });
  
  factory AppConfigDto.fromJson(Map<String, Object?> json) => _$AppConfigDtoFromJson(json);
  
  final AppVersionDto partner;
  final AppVersionDto customer;
  final AppVersionDto admin;

  /// How to reach our team (forgotten passwords, adding a store, help).
  final SupportContactDto support;

  /// How the customer app browses offers.
  final BrowseConfigDto browse;

  Map<String, Object?> toJson() => _$AppConfigDtoToJson(this);
}
