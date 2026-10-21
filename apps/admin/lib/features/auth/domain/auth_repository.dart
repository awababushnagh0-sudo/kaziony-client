import 'package:kernel/kernel.dart';

/// Signing in and out of the dashboard.
abstract interface class AuthRepository {
  Future<Result<SessionUser>> login(String email, String password);

  Future<Result<SessionUser>> changePassword(
    String currentPassword,
    String newPassword,
  );

  Future<void> logout();
}

/// Wired to the real implementation in `app/dependencies.dart`.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => throw UnimplementedError('Provided by app/dependencies.dart'),
);
