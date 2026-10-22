import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/record/record_form.dart';
import '../domain/dashboard_user.dart';
import 'user_details_view_model.dart';

/// A user's own fields, edited on their page. The email is their login,
/// so it's shown but not edited, and admins can't change their own role.
class UserFormViewModel extends RecordForm<DashboardUser> {
  UserFormViewModel(this.userId);

  final String userId;

  @override
  AsyncNotifierProvider<UserDetailsViewModel, DashboardUser> get record =>
      userDetailsViewModel(userId);

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
  Future<Result<DashboardUser>> submit() => ref
      .read(record.notifier)
      .save(
        EditedDashboardUser(
          name: text('name')!,
          role: form.control('role').value as DashboardRole,
        ),
      );
}

final userFormViewModel = NotifierProvider.autoDispose
    .family<UserFormViewModel, RecordFormState, String>(UserFormViewModel.new);
