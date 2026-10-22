// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_dashboard_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatedDashboardUserDto _$CreatedDashboardUserDtoFromJson(
  Map<String, dynamic> json,
) => CreatedDashboardUserDto(
  user: AdminUserDto.fromJson(json['user'] as Map<String, dynamic>),
  temporaryPassword: json['temporaryPassword'] as String,
);

Map<String, dynamic> _$CreatedDashboardUserDtoToJson(
  CreatedDashboardUserDto instance,
) => <String, dynamic>{
  'user': instance.user,
  'temporaryPassword': instance.temporaryPassword,
};
