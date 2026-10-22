import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../domain/auth_repository.dart';

enum LoginProblem { wrongCredentials, accountDisabled, notStoreAccount }

class LoginState {
  const LoginState({this.submitting = false, this.problem, this.failure});

  final bool submitting;

  /// A problem the screen explains in its own words.
  final LoginProblem? problem;

  /// Any other failure (no connection, server error, ...).
  final AppFailure? failure;
}

class LoginViewModel extends ViewModel<LoginState> {
  late final FormGroup form;

  @override
  LoginState build() {
    form = FormGroup({
      'phone': FormControl<String>(
        validators: [Validators.required, SValidators.libyanPhone],
      ),
      'password': FormControl<String>(validators: [Validators.required]),
    });
    ref.onDispose(form.dispose);
    return const LoginState();
  }

  Future<void> submit() async {
    if (state.submitting) return;
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }
    state = const LoginState(submitting: true);

    final phone = normalizeLibyanPhone(form.control('phone').value as String)!;
    final password = form.control('password').value as String;
    final auth = ref.read(authRepositoryProvider);
    final result = await auth.login(phone, password);
    if (!ref.mounted) return;

    switch (result) {
      case Ok(:final value) when value.role != AccountRole.merchant:
        // A customer or admin account: this app is only for stores.
        await auth.logout();
        if (ref.mounted) {
          state = const LoginState(problem: LoginProblem.notStoreAccount);
        }
      case Ok():
        // The router moves on to the next screen when the session changes.
        state = const LoginState();
      case Err(failure: UnauthorizedFailure()):
        state = const LoginState(problem: LoginProblem.wrongCredentials);
      case Err(failure: ForbiddenFailure()):
        state = const LoginState(problem: LoginProblem.accountDisabled);
      case Err(:final failure):
        state = LoginState(failure: failure);
    }
  }
}

final loginViewModel = NotifierProvider.autoDispose<LoginViewModel, LoginState>(
  LoginViewModel.new,
);
