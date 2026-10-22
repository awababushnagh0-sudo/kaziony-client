import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../domain/auth_repository.dart';

class ChangePasswordState {
  const ChangePasswordState({
    this.submitting = false,
    this.wrongCurrentPassword = false,
    this.failure,
  });

  final bool submitting;
  final bool wrongCurrentPassword;
  final AppFailure? failure;
}

class ChangePasswordViewModel extends ViewModel<ChangePasswordState> {
  static const minLength = 8;

  late final FormGroup form;

  @override
  ChangePasswordState build() {
    form = FormGroup(
      {
        'current': FormControl<String>(validators: [Validators.required]),
        'password': FormControl<String>(
          validators: [Validators.required, Validators.minLength(minLength)],
        ),
        'confirm': FormControl<String>(validators: [Validators.required]),
      },
      validators: [Validators.mustMatch('password', 'confirm')],
    );
    ref.onDispose(form.dispose);
    return const ChangePasswordState();
  }

  /// Returns true when the password was changed.
  Future<bool> submit() async {
    if (state.submitting) return false;
    if (form.invalid) {
      form.markAllAsTouched();
      return false;
    }
    state = const ChangePasswordState(submitting: true);

    final result = await ref
        .read(authRepositoryProvider)
        .changePassword(
          form.control('current').value as String,
          form.control('password').value as String,
        );
    if (!ref.mounted) return false;

    state = switch (result) {
      Ok() => const ChangePasswordState(),
      Err(failure: UnauthorizedFailure()) => const ChangePasswordState(
        wrongCurrentPassword: true,
      ),
      Err(:final failure) => ChangePasswordState(failure: failure),
    };
    return result.isOk;
  }

  Future<void> logout() => ref.read(authRepositoryProvider).logout();
}

final changePasswordViewModel =
    NotifierProvider.autoDispose<ChangePasswordViewModel, ChangePasswordState>(
      ChangePasswordViewModel.new,
    );
