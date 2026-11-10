import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/store_image_field.dart';
import '../../auth/domain/auth_repository.dart';
import '../../store/domain/current_store.dart';
import '../../store/domain/store.dart';
import '../../store/presentation/store_view_model.dart';

/// The store as customers see it across the top (its cover, logo, name,
/// category and area), then the store's info, place and team, the
/// member's own account, the app's settings and help. Owners change the
/// cover and logo right there. The page doesn't wait for the store's
/// details: the name, area and logo come with the sign-in, and the rest
/// fills in once loaded.
class ProfileScreen extends AppView {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final stellar = StellarLocalizations.of(context);
    final membership = ref.watch(currentStoreProvider);
    final details = ref.watch(storeViewModel).value;
    Future<void> refresh() async {
      final failure = await ref.read(storeViewModel.notifier).refresh();
      if (failure != null && context.mounted) {
        SSnack.error(context, failureMessage(context, failure));
      }
    }

    return SScaffold(
      // The store's cover says whose page it is; the tab says it's the
      // profile.
      showAppBar: false,
      scrollable: true,
      // What the team changed (the name, the category) shows without
      // signing in again.
      onRefresh: refresh,
      padded: false,
      underStatusBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.xl,
        children: [
          if (membership != null)
            _StoreHeader(membership: membership, details: details),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Space.xl,
              children: [
                if (membership != null)
                  _YourStore(membership: membership, details: details),
                _YourAccount(membership),
                SListGroup(
                  title: s.appSection,
                  separated: true,
                  children: [
                    SListTile(
                      icon: SIcons.language,
                      title: stellar.language,
                      value: languageName(ref.watch(localeProvider)),
                      onTap: () => chooseLanguage(context, ref),
                    ),
                    SListTile(
                      icon: SIcons.appearance,
                      title: stellar.theme,
                      value: themeName(context, ref.watch(themeChoiceProvider)),
                      onTap: () => chooseTheme(context, ref),
                    ),
                  ],
                ),
                SListGroup(
                  title: s.helpSection,
                  separated: true,
                  children: [
                    SListTile(
                      icon: SIcons.chat,
                      title: s.contactUs,
                      onTap: () => context.push(Routes.contact),
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
        ],
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
}

/// The cover and the logo over its edge, then the store's name, its
/// category and its area: the area tells a brand's places apart.
class _StoreHeader extends StatelessWidget {
  const _StoreHeader({required this.membership, required this.details});

  final StoreMembership membership;

  /// Null until the store's details load.
  final Store? details;

  @override
  Widget build(BuildContext context) {
    final details = this.details;
    final owner = membership.isOwner;
    final category = details?.category.name(Localizations.localeOf(context));
    final area = details == null ? membership.storeArea : details.area;
    final about = [?category, ?area].where((part) => part.isNotEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        SCoverWithLogo(
          cover: StoreImageField(
            image: StoreImage.cover,
            url: details?.coverUrl,
            editable: owner,
            shape: PhotoFieldShape.banner,
          ),
          logo: StoreImageField(
            image: StoreImage.logo,
            // The one from the sign-in until the store's own loads.
            url: details == null ? membership.storeLogoUrl : details.logoUrl,
            editable: owner,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText.title(details?.name ?? membership.storeName),
              if (about.isNotEmpty)
                SText(about.join(' · '), color: SColor.textMuted),
            ],
          ),
        ),
      ],
    );
  }
}

/// The store's info, as customers see it (owners edit it there), and
/// where it is, with its area. For owners, the team too, with how many.
class _YourStore extends StatelessWidget {
  const _YourStore({required this.membership, required this.details});

  final StoreMembership membership;
  final Store? details;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final details = this.details;
    return SListGroup(
      title: s.yourStoreSection,
      separated: true,
      children: [
        SListTile(
          icon: SIcons.store,
          title: s.storeInfoTitle,
          onTap: () => context.push(Routes.storeInfo),
        ),
        SListTile(
          icon: SIcons.location,
          title: s.locationTitle,
          value: details == null ? membership.storeArea : details.area,
          onTap: () => context.push(Routes.location),
        ),
        if (membership.isOwner)
          SListTile(
            icon: SIcons.users,
            title: s.teamTitle,
            value: details == null ? null : '${details.members.length}',
            onTap: () => context.push(Routes.team),
          ),
      ],
    );
  }
}

/// Who's signed in, with their role here, and what they can change about
/// their own account.
class _YourAccount extends AppView {
  const _YourAccount(this.membership);

  final StoreMembership? membership;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final membership = this.membership;
    final user = switch (ref.watch(sessionProvider)) {
      SignedIn(:final user) => user,
      _ => null,
    };
    final name = user?.name?.trim();
    final phone = switch (user?.phone) {
      // "091 000 0001" keeps its order in Arabic.
      final phone? => '\u2066${formatLibyanPhone(phone)}\u2069',
      null => null,
    };
    final named = name != null && name.isNotEmpty;
    final title = named ? name : phone;
    return SListGroup(
      title: s.accountSection,
      separated: true,
      children: [
        if (title != null)
          SListTile(
            icon: SIcons.user,
            title: title,
            subtitle: named ? phone : null,
            trailing: switch (membership?.isOwner) {
              true => SBadge(
                s.ownerRole,
                tone: BadgeTone.brand,
                size: BadgeSize.large,
                icon: SIcons.crown,
              ),
              false => SBadge(s.staffRole, size: BadgeSize.large),
              null => null,
            },
          ),
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
    );
  }

  Future<void> _switchStore(BuildContext context, WidgetRef ref) async {
    final chosen = await SSheet.choose(
      context,
      title: PartnerLocalizations.of(context).switchStore,
      options: [
        for (final store in ref.read(myStoresProvider))
          RadioOption(value: store.storeId, label: store.label),
      ],
      selected: ref.read(currentStoreProvider)?.storeId,
    );
    if (chosen == null) return;
    await ref.read(chosenStoreProvider.notifier).choose(chosen);
    // Show the store they switched to.
    if (context.mounted) context.go(Routes.home);
  }
}
