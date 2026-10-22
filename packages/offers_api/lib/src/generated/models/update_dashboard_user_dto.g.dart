// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_dashboard_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateDashboardUserDto _$UpdateDashboardUserDtoFromJson(
  Map<String, dynamic> json,
) => UpdateDashboardUserDto(
  role: json['role'] == null ? null : TeamRole.fromJson(json['role'] as String),
  name: json['name'] as String?,
);

Map<String, dynamic> _$UpdateDashboardUserDtoToJson(
  UpdateDashboardUserDto instance,
) => <String, dynamic>{'role': ?instance.role, 'name': ?instance.name};
