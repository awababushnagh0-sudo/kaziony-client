import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/providers/access.dart';
import '../../../core/record/record_form.dart';
import '../domain/dashboard_user.dart';
import 'user_details_view_model.dart';

/// A user's own fields, edited on their page. The email is their login,
/// so it's shown but not edited, and admins can't change their own role.
/// Only a developer edits a developer, and a developer's role is only
/// code's to change.
class UserFormViewModel extends RecordForm<DashboardUser> {
  UserFormViewModel(this.userId);

  final String userId;

  @override
  AsyncNotifierProvider<UserDetailsViewModel, DashboardUser> get record =>
      userDetailsViewModel(userId);

  @override
  RecordFormState build() {
    final state = super.build();
    ref.listen(record, (_, next) => _lock(next.value), fireImmediately: true);
    return state;
  }

  void _lock(DashboardUser? user) {
    if (user?.role != DashboardRole.developer) return;
    form.control('role').markAsDisabled();
    if (!ref.read(isDeveloperProvider)) form.control('name').markAsDisabled();
  }

  @override
  Map<String, AbstractControl<Object?>> fields() {
    final yourself = switch (ref.read(sessionProvider)) {
      SignedIn(:final user) => user.id == userId,
      _ => false,
    };
    return {
      'name': FormControl<String>(
        validators: [Validators.required, Validators.maxLength(100)],
      ),
      'email': FormControl<String>(disabled: true),
      'role': FormControl<DashboardRole>(
        validators: [Validators.required],
        disabled: yourself,
      ),
    };
  }

  @override
  Map<String, Object?> valuesOf(DashboardUser user) => {
    'name': user.name,
    'email': user.email,
    'role': user.role,
  };

  @override
  Future<Result<DashboardUser>> submit() {
    final role = form.control('role');
    return ref
        .read(record.notifier)
        .save(
          EditedDashboardUser(
            name: text('name')!,
            role: role.enabled ? role.value as DashboardRole : null,
          ),
        );
  }
}

final userFormViewModel = NotifierProvider.autoDispose
    .family<UserFormViewModel, RecordFormState, String>(UserFormViewModel.new);
