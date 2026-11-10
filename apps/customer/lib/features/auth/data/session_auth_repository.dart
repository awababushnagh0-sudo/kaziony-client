import 'package:kernel/kernel.dart';
import 'package:offers_api/auth.dart' show AuthClient;

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

  @override
  Future<Result<void>> deleteAccount() async {
    final api = _ref.read(apiProvider);
    final result = await api.guard(() => api.client(AuthClient.new).deleteMe());
    // The account is gone with its tokens: only the phone's copy is left.
    if (result is Ok) await _session.signOut();
    return result;
  }
}
