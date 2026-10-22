import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/list/paged_table.dart';
import '../../../core/routes/routes.dart';
import '../domain/dashboard_user.dart';
import 'add_user_dialog.dart';
import 'role_label.dart';
import 'user_login_dialog.dart';
import 'users_view_model.dart';

/// Our team on the dashboard, ERPNext-style: search and filter by role, a
/// table, a pager, and "Add user". Only admins see it.
class UsersScreen extends AppView {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);

    Future<void> addUser() async {
      final created = await SDialog.show<CreatedDashboardUser>(
        context,
        (_) => const AddUserDialog(),
        dismissible: false,
      );
      if (created == null || !context.mounted) return;
      ref.invalidate(userPageProvider);
      final user = created.user;
      await SDialog.show<void>(
        context,
        (_) => UserLoginDialog(
          title: s.userCreatedTitle,
          message: s.userCreatedMessage(user.name ?? user.email),
          email: user.email,
          password: created.temporaryPassword,
        ),
        dismissible: false,
      );
    }

    return SScaffold(
      title: s.usersTitle,
      padded: false,
      actions: [
        SButton(label: s.addUser, icon: SIcons.add, onPressed: addUser),
      ],
      body: PagedTable<DashboardUser, DashboardRole>(
        query: userQueryProvider,
        page: userPageProvider,
        searchHint: s.usersSearch,
        filters: [
          (DashboardRole.admin, s.filterAdmins),
          (DashboardRole.editor, s.filterEditors),
        ],
        totalLabel: s.usersTotal,
        columns: _columns(context),
        onOpen: (user) => context.go(Routes.user(user.id)),
        empty: SEmptyView(
          title: s.usersEmpty,
          message: s.usersEmptyMessage,
          icon: SIcons.users,
          actionLabel: s.addUser,
          onAction: addUser,
        ),
      ),
    );
  }

  List<TableColumn<DashboardUser>> _columns(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return [
      TableColumn(
        label: s.columnName,
        flex: 2,
        cell: (user) => SCellText(user.name ?? user.email, strong: true),
      ),
      TableColumn(
        label: s.columnEmail,
        flex: 3,
        minWidth: 560,
        cell: (user) => SCellText(user.email, ltr: true),
      ),
      TableColumn(
        label: s.columnRole,
        cell: (user) => Align(
          alignment: AlignmentDirectional.centerStart,
          child: user.role == DashboardRole.admin
              ? SBadge(roleLabel(s, user.role), tone: BadgeTone.warning)
              : SBadge(roleLabel(s, user.role)),
        ),
      ),
      TableColumn(
        label: s.columnStatus,
        cell: (user) => Align(
          alignment: AlignmentDirectional.centerStart,
          child: user.isActive
              ? SBadge(s.userActive, tone: BadgeTone.success)
              : SBadge(s.userDisabled),
        ),
      ),
      TableColumn(
        label: s.columnLastLogin,
        minWidth: 760,
        cell: (user) => switch (user.lastLoginAt) {
          null => SCellText(s.neverLoggedIn),
          final at => SCellText(formatDate(at, languageCode: language)),
        },
      ),
      TableColumn(
        label: s.columnAdded,
        minWidth: 900,
        cell: (user) =>
            SCellText(formatDate(user.createdAt, languageCode: language)),
      ),
    ];
  }
}
