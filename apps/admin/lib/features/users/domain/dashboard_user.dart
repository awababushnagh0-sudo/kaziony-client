import 'package:kernel/kernel.dart';

import '../../../core/list/list_query.dart';

/// What someone on our team may do on the dashboard. Editors can add and
/// edit, but can't delete or take things down, and can't manage users.
enum DashboardRole { admin, editor }

/// Someone on our team, a row in the users list.
class DashboardUser {
  const DashboardUser({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.name,
    this.lastLoginAt,
  });

  final String id;
  final String? name;
  final String email;
  final DashboardRole role;
  final bool isActive;
  final DateTime createdAt;

  /// Null until they first log in.
  final DateTime? lastLoginAt;
}

/// Null (no filter) shows both roles.
typedef DashboardUserQuery = ListQuery<DashboardRole>;
typedef DashboardUserPage = PageResult<DashboardUser>;

/// Someone to add to the team, as entered by an admin.
class NewDashboardUser {
  const NewDashboardUser({
    required this.name,
    required this.email,
    required this.role,
  });

  final String name;
  final String email;
  final DashboardRole role;
}

/// A user's own fields as an admin edited them. Their email is their login
/// and stays as it is.
class EditedDashboardUser {
  const EditedDashboardUser({required this.name, required this.role});

  final String name;
  final DashboardRole role;
}

/// What to hand to the new user.
class CreatedDashboardUser {
  const CreatedDashboardUser({
    required this.user,
    required this.temporaryPassword,
  });

  final DashboardUser user;

  /// Shown once; they choose their own on their first login.
  final String temporaryPassword;
}

abstract interface class DashboardUserRepository {
  Future<Result<DashboardUserPage>> list(DashboardUserQuery query);
  Future<Result<DashboardUser>> get(String id);

  /// Fails with a [ValidationFailure] when admins change their own role.
  Future<Result<DashboardUser>> update(String id, EditedDashboardUser user);

  /// Disabling logs them out everywhere.
  Future<Result<DashboardUser>> setActive(String id, {required bool active});

  /// A new temporary password, shown once; they choose their own when they
  /// next log in. Logs them out everywhere.
  Future<Result<String>> resetPassword(String id);

  /// Fails with a [ConflictFailure] when the email already has an account.
  Future<Result<CreatedDashboardUser>> create(NewDashboardUser user);
}

/// Wired to the real implementation in `app/dependencies.dart`.
final dashboardUserRepositoryProvider = Provider<DashboardUserRepository>(
  (ref) => throw UnimplementedError('Provided by app/dependencies.dart'),
);
