import 'package:kernel/kernel.dart';

import '../domain/dashboard_user.dart';
import 'users_view_model.dart';

/// One user's details, and the admin's actions on them.
class UserDetailsViewModel extends AsyncViewModel<DashboardUser> {
  UserDetailsViewModel(this.userId);

  final String userId;

  DashboardUserRepository get _users =>
      ref.read(dashboardUserRepositoryProvider);

  @override
  Future<DashboardUser> build() async {
    final result = await ref.watch(dashboardUserRepositoryProvider).get(userId);
    return switch (result) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  Future<Result<DashboardUser>> save(EditedDashboardUser edited) =>
      _apply(_users.update(userId, edited));

  Future<Result<DashboardUser>> setActive({required bool active}) =>
      _apply(_users.setActive(userId, active: active));

  /// Their new temporary password.
  Future<Result<String>> resetPassword() => _users.resetPassword(userId);

  Future<Result<DashboardUser>> _apply(
    Future<Result<DashboardUser>> change,
  ) async {
    final result = await change;
    if (result case Ok(:final value) when ref.mounted) {
      state = AsyncData(value);
      // The list beneath shows the name, role and status too.
      ref.invalidate(userPageProvider);
    }
    return result;
  }
}

final userDetailsViewModel = AsyncNotifierProvider.autoDispose
    .family<UserDetailsViewModel, DashboardUser, String>(
      UserDetailsViewModel.new,
    );
