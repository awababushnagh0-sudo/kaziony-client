import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/record/record_screen.dart';
import '../../../core/routes/routes.dart';
import '../domain/dashboard_user.dart';
import 'role_label.dart';
import 'user_details_view_model.dart';
import 'user_form_view_model.dart';
import 'user_login_dialog.dart';

/// One user, ERPNext-style: "Users / name" with their status and an
/// actions menu (reset password, disable), their fields edited in place,
/// and a side panel with their role and last login.
class UserDetailsScreen extends AppStatefulView {
  const UserDetailsScreen({required this.userId, super.key});

  final String userId;

  @override
  AppViewState<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends AppViewState<UserDetailsScreen> {
  /// An action is on its way; the menu waits for it.
  var _busy = false;

  UserDetailsViewModel get _viewModel =>
      ref.read(userDetailsViewModel(widget.userId).notifier);

  Future<void> _resetPassword(DashboardUser user) async {
    final s = AdminLocalizations.of(context);
    final name = user.name ?? user.email;
    final confirmed = await SDialog.confirm(
      context,
      title: s.resetPasswordTitle(name),
      message: s.resetPasswordMessage,
      confirmLabel: s.resetPassword,
    );
    if (!confirmed || !mounted) return;
    setState(() => _busy = true);
    final result = await _viewModel.resetPassword();
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok(value: final password):
        await SDialog.show<void>(
          context,
          (_) => UserLoginDialog(
            title: s.newPasswordTitle,
            message: s.newPasswordMessage(name),
            email: user.email,
            password: password,
          ),
          dismissible: false,
        );
      case Err(:final failure):
        SSnack.error(context, failureMessage(context, failure));
    }
  }

  Future<void> _setActive(DashboardUser user, {required bool active}) async {
    final s = AdminLocalizations.of(context);
    if (!active) {
      final confirmed = await SDialog.confirm(
        context,
        title: s.disableUserTitle(user.name ?? user.email),
        message: s.disableUserMessage,
        confirmLabel: s.disableUser,
        destructive: true,
      );
      if (!confirmed || !mounted) return;
    }
    setState(() => _busy = true);
    final result = await _viewModel.setActive(active: active);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok():
        SSnack.success(
          context,
          active ? s.userEnabledDone : s.userDisabledDone,
        );
      case Err(:final failure):
        SSnack.error(context, failureMessage(context, failure));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final yourself = switch (ref.watch(sessionProvider)) {
      SignedIn(:final user) => user.id == widget.userId,
      _ => false,
    };
    return RecordScreen(
      record: userDetailsViewModel(widget.userId),
      form: userFormViewModel(widget.userId),
      parent: ScaffoldParent(
        label: s.usersTitle,
        onTap: () => context.go(Routes.users),
      ),
      title: (user) => user.name ?? user.email,
      status: (user) => user.isActive
          ? SBadge(s.userActive, tone: BadgeTone.success)
          : SBadge(s.userDisabled),
      actions: (user) => [
        SMenuButton(
          width: 260,
          entries: [
            MenuEntry(
              label: s.resetPassword,
              description: s.resetPasswordHint,
              icon: SIcons.key,
              onTap: () => _resetPassword(user),
            ),
            // Admins can't lock themselves out.
            if (!yourself) ...[
              null,
              if (user.isActive)
                MenuEntry(
                  label: s.disableUser,
                  description: s.disableUserHint,
                  icon: SIcons.disable,
                  destructive: true,
                  onTap: () => _setActive(user, active: false),
                )
              else
                MenuEntry(
                  label: s.enableUser,
                  icon: SIcons.enable,
                  onTap: () => _setActive(user, active: true),
                ),
            ],
          ],
          builder: (context, toggle) =>
              SButton.menu(label: s.actions, onPressed: _busy ? null : toggle),
        ),
      ],
      builder: (context, user) => _UserRecord(user: user),
    );
  }
}

class _UserRecord extends StatelessWidget {
  const _UserRecord({required this.user});

  final DashboardUser user;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final lastLogin = user.lastLoginAt;

    return SRecordPage(
      tabs: [
        RecordTab(
          label: s.tabDetails,
          child: SFormSection(
            title: s.tabDetails,
            divider: false,
            child: SFieldGrid(
              columns: 3,
              children: [
                STextInput(
                  controlName: 'name',
                  label: s.userName,
                  required: true,
                ),
                STextInput(
                  controlName: 'email',
                  label: s.userEmail,
                  kind: TextInputKind.email,
                ),
                SSelectInput<DashboardRole>(
                  controlName: 'role',
                  label: s.userRole,
                  required: true,
                  options: [
                    for (final role in DashboardRole.values)
                      SelectOption(role, roleLabel(s, role)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      sidebar: [
        SRecordProfile(
          title: user.name ?? user.email,
          subtitle: roleLabel(s, user.role),
        ),
        SRecordFacts([
          RecordFact(
            s.columnLastLogin,
            lastLogin == null
                ? s.neverLoggedIn
                : formatDate(lastLogin, languageCode: language),
          ),
          RecordFact(
            s.columnAdded,
            formatDate(user.createdAt, languageCode: language),
          ),
        ]),
      ],
    );
  }
}
