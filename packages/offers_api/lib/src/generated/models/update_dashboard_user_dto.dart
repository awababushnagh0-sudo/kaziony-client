// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'team_role.dart';

part 'update_dashboard_user_dto.g.dart';

@JsonSerializable()
class UpdateDashboardUserDto {
  const UpdateDashboardUserDto({
    this.role,
    this.name,
  });
  
  factory UpdateDashboardUserDto.fromJson(Map<String, Object?> json) => _$UpdateDashboardUserDtoFromJson(json);
  
  /// Editors can't delete or take things down, and can't manage the team.
  final TeamRole? role;
  final String? name;

  Map<String, Object?> toJson() => _$UpdateDashboardUserDtoToJson(this);
}
