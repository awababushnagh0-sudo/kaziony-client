// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/admin_user_dto.dart';
import '../models/create_dashboard_user_dto.dart';
import '../models/created_dashboard_user_dto.dart';
import '../models/reset_password_response_dto.dart';
import '../models/set_user_status_dto.dart';
import '../models/team_role.dart';
import '../models/update_dashboard_user_dto.dart';
import '../models/user_list_dto.dart';
import '../models/user_role.dart';

part 'admin_users_client.g.dart';

@RestApi()
abstract class AdminUsersClient {
  factory AdminUsersClient(Dio dio, {String? baseUrl}) = _AdminUsersClient;

  /// List and search users.
  ///
  /// [search] - Search by name, email or phone.
  @GET('/api/v1/admin/users')
  Future<UserListDto> list({
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('role') UserRole? role,
    @Query('search') String? search,
    @Query('isActive') bool? isActive,
  });

  /// Add an admin or editor to the dashboard.
  ///
  /// Their temporary password is shown only once; they must change it on their first login.
  @POST('/api/v1/admin/users')
  Future<CreatedDashboardUserDto> create({
    @Body() required CreateDashboardUserDto body,
  });

  /// List and search our team: admins and editors.
  ///
  /// [search] - Search by name, email or phone.
  ///
  /// [role] - Only admins or only editors; both when empty.
  @GET('/api/v1/admin/users/team')
  Future<UserListDto> listTeam({
    @Query('search') String? search,
    @Query('isActive') bool? isActive,
    @Query('role') TeamRole? role,
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
  });

  /// One user
  @GET('/api/v1/admin/users/{id}')
  Future<AdminUserDto> getUser({
    @Path('id') required String id,
  });

  /// Rename an admin or editor, or change their role.
  ///
  /// Admins cannot change their own role.
  @PATCH('/api/v1/admin/users/{id}')
  Future<AdminUserDto> update({
    @Path('id') required String id,
    @Body() required UpdateDashboardUserDto body,
  });

  /// Disable or enable an account
  @PATCH('/api/v1/admin/users/{id}/status')
  Future<AdminUserDto> setStatus({
    @Path('id') required String id,
    @Body() required SetUserStatusDto body,
  });

  /// Give a merchant/admin a new temporary password.
  ///
  /// Logs them out everywhere. The password is shown only once.
  @POST('/api/v1/admin/users/{id}/reset-password')
  Future<ResetPasswordResponseDto> resetPassword({
    @Path('id') required String id,
  });
}
