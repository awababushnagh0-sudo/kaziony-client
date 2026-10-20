import 'package:kernel/kernel.dart';

/// Logging in and out of the business app.
abstract interface class AuthRepository {
  /// [phone] is already normalized (+2189XXXXXXXX).
  Future<Result<SessionUser>> login(String phone, String password);

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
