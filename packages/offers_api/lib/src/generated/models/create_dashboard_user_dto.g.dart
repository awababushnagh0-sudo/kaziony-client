// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_dashboard_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateDashboardUserDto _$CreateDashboardUserDtoFromJson(
  Map<String, dynamic> json,
) => CreateDashboardUserDto(
  role: TeamRole.fromJson(json['role'] as String),
  name: json['name'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$CreateDashboardUserDtoToJson(
  CreateDashboardUserDto instance,
) => <String, dynamic>{
  'role': instance.role,
  'name': instance.name,
  'email': instance.email,
};
