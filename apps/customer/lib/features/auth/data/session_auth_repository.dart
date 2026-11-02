import 'package:kernel/kernel.dart';

import '../domain/auth_repository.dart';

/// Uses the shared session from kernel, which talks to Google and the
/// backend and keeps the tokens.
class SessionAuthRepository implements AuthRepository {
  SessionAuthRepository(this._ref);

  final Ref _ref;

  SessionController get _session => _ref.read(sessionProvider.notifier);

  @override
  Future<Result<SessionUser?>> signInWithGoogle() =>
      _session.signInWithGoogle();

  @override
  Future<void> signOut() => _session.signOut();
}
