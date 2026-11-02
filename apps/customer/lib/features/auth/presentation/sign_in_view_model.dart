import 'package:kernel/kernel.dart';

import '../domain/auth_repository.dart';

class SignInState {
  const SignInState({this.signingIn = false, this.failure});

  final bool signingIn;

  /// Why the last try failed (no connection, Google unavailable, ...).
  final AppFailure? failure;
}

class SignInViewModel extends ViewModel<SignInState> {
  @override
  SignInState build() => const SignInState();

  /// True once signed in; false when the customer closed Google's sheet or
  /// it failed (the state says why).
  Future<bool> signInWithGoogle() async {
    if (state.signingIn) return false;
    state = const SignInState(signingIn: true);
    final result = await ref.read(authRepositoryProvider).signInWithGoogle();
    if (!ref.mounted) return false;
    switch (result) {
      case Ok(value: null):
        state = const SignInState();
        return false;
      case Ok():
        state = const SignInState();
        return true;
      case Err(:final failure):
        state = SignInState(failure: failure);
        return false;
    }
  }
}

final signInViewModel =
    NotifierProvider.autoDispose<SignInViewModel, SignInState>(
      SignInViewModel.new,
    );
