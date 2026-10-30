import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../auth/domain/auth_repository.dart';
import '../../store/domain/current_store.dart';

/// Who's signed in and where: the store with the member's role, name and
/// phone; the store's pages as pictured cards; then the account and the
/// app's settings, each row a card that opens its own page.
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
    return SScaffold(
      // The header says whose profile it is; the tab says it's the profile.
      showAppBar: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.xl,
          children: [
            if (store != null)
              SProfileHeader(
                title: store.storeName,
                imageUrl: store.storeLogoUrl,
                badge: store.isOwner ? s.ownerRole : s.staffRole,
                badgeTone: store.isOwner
                    ? BadgeTone.success
                    : BadgeTone.neutral,
                subtitle: user?.name,
                phone: switch (user?.phone) {
                  final phone? => formatLibyanPhone(phone),
                  null => null,
                },
              ),
            // The store's own pages, the ones opened most.
            SShortcuts([
              Shortcut(
                illustration: SIllustrations.storeInfo,
                label: s.storeInfoTitle,
                onTap: () => context.push(Routes.storeInfo),
              ),
              Shortcut(
                illustration: SIllustrations.branches,
                label: s.branchesTitle,
                onTap: () => context.push(Routes.branches),
              ),
              Shortcut(
                illustration: SIllustrations.team,
                label: s.teamTitle,
                onTap: () => context.push(Routes.team),
              ),
            ]),
            SListGroup(
              title: s.accountSection,
              separated: true,
              children: [
                if (ref.watch(myStoresProvider).length > 1)
                  SListTile(
                    icon: SIcons.chevronUpDown,
                    title: s.switchStore,
                    onTap: () => _switchStore(context, ref),
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
              separated: true,
              children: [
                SListTile(
                  icon: SIcons.language,
                  title: StellarLocalizations.of(context).language,
                  value: languageName(ref.watch(localeProvider)),
                  onTap: () => chooseLanguage(context, ref),
                ),
                SListTile(
                  icon: SIcons.appearance,
                  title: StellarLocalizations.of(context).theme,
                  value: themeName(context, ref.watch(themeChoiceProvider)),
                  onTap: () => chooseTheme(context, ref),
                ),
                SListTile(
                  icon: SIcons.info,
                  title: s.aboutTitle,
                  onTap: () => context.push(Routes.about),
                ),
                SListTile(
                  icon: SIcons.document,
                  title: s.termsTitle,
                  onTap: () => context.push(Routes.terms),
                ),
              ],
            ),
            SButton.dangerSecondary(
              label: s.logout,
              icon: SIcons.logout,
              expand: true,
              onPressed: () => _logout(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  /// Asks first: signing back in needs the password, which a member at a
  /// busy counter may not have at hand.
  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final s = PartnerLocalizations.of(context);
    final confirmed = await SDialog.confirm(
      context,
      title: s.logoutTitle,
      message: s.logoutMessage,
      confirmLabel: s.logout,
      destructive: true,
    );
    if (confirmed) await ref.read(authRepositoryProvider).logout();
  }

  Future<void> _switchStore(BuildContext context, WidgetRef ref) async {
    final chosen = await SSheet.choose(
      context,
      title: PartnerLocalizations.of(context).switchStore,
      options: [
        for (final store in ref.read(myStoresProvider))
          RadioOption(value: store.storeId, label: store.storeName),
      ],
      selected: ref.read(currentStoreProvider)?.storeId,
    );
    if (chosen == null) return;
    await ref.read(chosenStoreProvider.notifier).choose(chosen);
    // Show the store they switched to.
    if (context.mounted) context.go(Routes.home);
  }
}
