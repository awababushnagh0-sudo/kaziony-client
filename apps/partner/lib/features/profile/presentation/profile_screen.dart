import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../auth/domain/auth_repository.dart';
import '../../store/domain/current_store.dart';

/// The store, the account and the app's settings, as rows that open their
/// own pages.
class ProfileScreen extends AppView {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final store = ref.watch(currentStoreProvider);
    final user = switch (ref.watch(sessionProvider)) {
      SignedIn(:final user) => user,
      _ => null,
    };
    final app = ref.watch(appInfoProvider);
    return SScaffold(
      title: s.profileTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.xl,
          children: [
            if (store != null)
              SListGroup(
                children: [
                  SListTile(
                    icon: SIcons.store,
                    title: store.storeName,
                    subtitle: store.isOwner ? s.ownerRole : s.staffRole,
                  ),
                ],
              ),
            SListGroup(
              title: s.storeSection,
              children: [
                SListTile(
                  icon: SIcons.info,
                  title: s.storeInfoTitle,
                  onTap: () => context.push(Routes.storeInfo),
                ),
                SListTile(
                  icon: SIcons.location,
                  title: s.branchesTitle,
                  onTap: () => context.push(Routes.branches),
                ),
                SListTile(
                  icon: SIcons.users,
                  title: s.teamTitle,
                  onTap: () => context.push(Routes.team),
                ),
                if (ref.watch(myStoresProvider).length > 1)
                  SListTile(
                    icon: SIcons.chevronUpDown,
                    title: s.switchStore,
                    onTap: () => _switchStore(context, ref),
                  ),
              ],
            ),
            SListGroup(
              title: s.accountSection,
              children: [
                if (user != null)
                  SListTile(
                    icon: SIcons.user,
                    title: user.name ?? s.notSet,
                    subtitle: user.phone == null
                        ? null
                        : formatLibyanPhone(user.phone!),
                  ),
                SListTile(
                  icon: SIcons.key,
                  title: s.changePasswordAction,
                  onTap: () => context.push(Routes.password),
                ),
              ],
            ),
            SListGroup(
              title: s.appSection,
              children: [
                SListTile(
                  icon: SIcons.language,
                  title: StellarLocalizations.of(context).language,
                  value: languageName(ref.watch(localeProvider)),
                  onTap: () => chooseLanguage(context, ref),
                ),
                SListTile(
                  icon: SIcons.device,
                  title: s.versionLabel,
                  value: '${app.version} (${app.buildNumber})',
                ),
              ],
            ),
            SButton.secondary(
              label: s.logout,
              icon: SIcons.logout,
              onPressed: () => ref.read(authRepositoryProvider).logout(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _switchStore(BuildContext context, WidgetRef ref) async {
    final chosen = await SSheet.choose(
      context,
      title: PartnerLocalizations.of(context).switchStore,
      options: [
        for (final store in ref.read(myStoresProvider))
          SheetOption(value: store.storeId, label: store.storeName),
      ],
      selected: ref.read(currentStoreProvider)?.storeId,
    );
    if (chosen == null) return;
    await ref.read(chosenStoreProvider.notifier).choose(chosen);
    // Show the store they switched to.
    if (context.mounted) context.go(Routes.home);
  }
}
