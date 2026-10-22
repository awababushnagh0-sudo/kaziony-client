// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'team_role.dart';

part 'create_dashboard_user_dto.g.dart';

@JsonSerializable()
class CreateDashboardUserDto {
  const CreateDashboardUserDto({
    required this.role,
    required this.name,
    required this.email,
  });
  
  factory CreateDashboardUserDto.fromJson(Map<String, Object?> json) => _$CreateDashboardUserDtoFromJson(json);
  
  /// Editors can't delete or take things down, and can't manage the team.
  final TeamRole role;
  final String name;

  /// Their login.
  final String email;

  Map<String, Object?> toJson() => _$CreateDashboardUserDtoToJson(this);
}
