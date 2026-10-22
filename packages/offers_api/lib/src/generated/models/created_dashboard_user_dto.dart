// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_user_dto.dart';

part 'created_dashboard_user_dto.g.dart';

@JsonSerializable()
class CreatedDashboardUserDto {
  const CreatedDashboardUserDto({
    required this.user,
    required this.temporaryPassword,
  });
  
  factory CreatedDashboardUserDto.fromJson(Map<String, Object?> json) => _$CreatedDashboardUserDtoFromJson(json);
  
  final AdminUserDto user;

  /// Shown only once. They must change it on their first login.
  final String temporaryPassword;

  Map<String, Object?> toJson() => _$CreatedDashboardUserDtoToJson(this);
}
