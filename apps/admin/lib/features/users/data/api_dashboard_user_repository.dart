import 'package:kernel/kernel.dart';
import 'package:offers_api/admin.dart';

import '../domain/dashboard_user.dart';

class ApiDashboardUserRepository implements DashboardUserRepository {
  ApiDashboardUserRepository(this._api);

  final Api _api;
  late final _users = _api.client(AdminUsersClient.new);

  @override
  Future<Result<DashboardUserPage>> list(DashboardUserQuery query) async {
    final result = await _api.guard(
      () => _users.listTeam(
        page: query.page,
        pageSize: query.pageSize,
        search: query.search.isEmpty ? null : query.search,
        role: switch (query.filter) {
          null => null,
          final role => _teamRole(role),
        },
      ),
    );
    return result.map(
      (dto) => DashboardUserPage(
        total: dto.meta.total.toInt(),
        items: [for (final user in dto.items) _toUser(user)],
      ),
    );
  }

  @override
  Future<Result<DashboardUser>> get(String id) async {
    final result = await _api.guard(() => _users.getUser(id: id));
    return result.map(_toUser);
  }

  @override
  Future<Result<DashboardUser>> update(
    String id,
    EditedDashboardUser user,
  ) async {
    final result = await _api.guard(
      () => _users.update(
        id: id,
        body: UpdateDashboardUserDto(
          name: user.name,
          role: _teamRole(user.role),
        ),
      ),
    );
    return result.map(_toUser);
  }

  @override
  Future<Result<DashboardUser>> setActive(
    String id, {
    required bool active,
  }) async {
    final result = await _api.guard(
      () => _users.setStatus(
        id: id,
        body: SetUserStatusDto(isActive: active),
      ),
    );
    return result.map(_toUser);
  }

  @override
  Future<Result<String>> resetPassword(String id) async {
    final result = await _api.guard(() => _users.resetPassword(id: id));
    return result.map((dto) => dto.temporaryPassword);
  }

  @override
  Future<Result<CreatedDashboardUser>> create(NewDashboardUser user) async {
    final result = await _api.guard(
      () => _users.create(
        body: CreateDashboardUserDto(
          name: user.name,
          email: user.email,
          role: _teamRole(user.role),
        ),
      ),
    );
    return result.map(
      (dto) => CreatedDashboardUser(
        user: _toUser(dto.user),
        temporaryPassword: dto.temporaryPassword,
      ),
    );
  }
}

TeamRole _teamRole(DashboardRole role) => switch (role) {
  DashboardRole.admin => TeamRole.admin,
  DashboardRole.editor => TeamRole.editor,
};

DashboardUser _toUser(AdminUserDto dto) => DashboardUser(
  id: dto.id,
  name: dto.name,
  // Team accounts always log in with an email.
  email: dto.email ?? '',
  // The team list only has admins and editors.
  role: dto.role == UserRole.admin ? DashboardRole.admin : DashboardRole.editor,
  isActive: dto.isActive,
  createdAt: dto.createdAt,
  lastLoginAt: dto.lastLoginAt,
);
