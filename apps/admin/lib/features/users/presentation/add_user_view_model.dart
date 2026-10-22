import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/dashboard_user.dart';

class AddUserState {
  const AddUserState({this.submitting = false, this.failure});

  final bool submitting;
  final AppFailure? failure;
}

/// Validation error key for an email that already has an account.
const emailTakenError = 'emailTaken';

class AddUserViewModel extends ViewModel<AddUserState> {
  late final FormGroup form;

  @override
  AddUserState build() {
    form = FormGroup({
      'name': FormControl<String>(
        validators: [Validators.required, Validators.maxLength(100)],
      ),
      'email': FormControl<String>(
        validators: [
          Validators.required,
          SValidators.email,
          Validators.maxLength(255),
        ],
      ),
      // The smaller role unless the admin chooses otherwise.
      'role': FormControl<DashboardRole>(
        value: DashboardRole.editor,
        validators: [Validators.required],
      ),
    });
    ref.onDispose(form.dispose);
    return const AddUserState();
  }

  /// The added user, or null when the form is invalid or saving failed
  /// (the form or the state then says why).
  Future<CreatedDashboardUser?> submit() async {
    if (state.submitting) return null;
    if (form.invalid) {
      form.markAllAsTouched();
      return null;
    }
    state = const AddUserState(submitting: true);
    final email = form.control('email');
    final result = await ref
        .read(dashboardUserRepositoryProvider)
        .create(
          NewDashboardUser(
            name: (form.control('name').value as String).trim(),
            email: (email.value as String).trim().toLowerCase(),
            role: form.control('role').value as DashboardRole,
          ),
        );
    if (!ref.mounted) return null;

    switch (result) {
      case Ok(:final value):
        state = const AddUserState();
        return value;
      // The only conflict: someone already logs in with this email.
      case Err(failure: ConflictFailure()):
        state = const AddUserState();
        email
          ..setErrors({emailTakenError: true})
          ..markAsTouched();
      case Err(:final failure):
        state = AddUserState(failure: failure);
    }
    return null;
  }
}

final addUserViewModel =
    NotifierProvider.autoDispose<AddUserViewModel, AddUserState>(
      AddUserViewModel.new,
    );
