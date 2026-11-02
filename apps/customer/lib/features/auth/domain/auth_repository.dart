import 'package:kernel/kernel.dart';

/// Signing customers in and out. Browsing needs no account; booking does.
abstract interface class AuthRepository {
  /// Google's account sheet, then our backend. Ok(null) when the customer
  /// closed the sheet without choosing an account.
  Future<Result<SessionUser?>> signInWithGoogle();

  Future<void> signOut();
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => throw UnimplementedError('Provided by core/providers'),
);
