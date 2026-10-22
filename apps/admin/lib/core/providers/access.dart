import 'package:kernel/kernel.dart';

/// Whether the signed-in user is an admin. Editors (the rest of the team)
/// don't see the Users page or the actions that can't be undone; the
/// backend refuses those to them too.
final isAdminProvider = Provider<bool>(
  (ref) => switch (ref.watch(sessionProvider)) {
    SignedIn(:final user) => user.role == AccountRole.admin,
    _ => false,
  },
);
