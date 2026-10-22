import 'package:kernel/kernel.dart';

import '../domain/auth_repository.dart';

/// Uses the shared session from kernel, which talks to the backend and
/// keeps the tokens.
class SessionAuthRepository implements AuthRepository {
  SessionAuthRepository(this._ref);

  final Ref _ref;

  SessionController get _session => _ref.read(sessionProvider.notifier);

  @override
  Future<Result<SessionUser>> login(String phone, String password) =>
      _session.loginWithPassword(phone, password);

  @override
  Future<Result<SessionUser>> changePassword(
    String currentPassword,
    String newPassword,
  ) => _session.changePassword(currentPassword, newPassword);

  @override
  Future<void> logout() => _session.signOut();
}
