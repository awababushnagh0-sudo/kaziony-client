import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/dashboard_user.dart';

/// "Admin" or "Editor", in the user's language.
String roleLabel(AdminLocalizations s, DashboardRole role) => switch (role) {
  DashboardRole.admin => s.roleAdmin,
  DashboardRole.editor => s.roleEditor,
};
