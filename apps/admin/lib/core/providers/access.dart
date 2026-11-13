import 'package:kernel/kernel.dart';

/// Whether the signed-in user is an admin, or a developer, who does all an
/// admin does. Editors (the rest of the team) don't see the Users page or
/// the actions that can't be undone; the backend refuses those to them too.
final isAdminProvider = Provider<bool>(
  (ref) => switch (ref.watch(sessionProvider)) {
    SignedIn(:final user) =>
      user.role == AccountRole.admin || user.role == AccountRole.developer,
    _ => false,
  },
);

/// Whether the signed-in user is one of us who build Kaziony: only they see
/// the System page, and only they change a developer's account.
final isDeveloperProvider = Provider<bool>(
  (ref) => switch (ref.watch(sessionProvider)) {
    SignedIn(:final user) => user.role == AccountRole.developer,
    _ => false,
  },
);
