import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/sign_in_prompt.dart';
import '../../auth/domain/auth_repository.dart';
import '../../location/domain/browse_location.dart';

/// Who's signed in, or the way to sign in; then the app's settings, which
/// work signed out too.
class AccountScreen extends AppView {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final stellar = StellarLocalizations.of(context);
    final user = switch (ref.watch(sessionProvider)) {
      SignedIn(:final user) => user,
      _ => null,
    };
    final place = switch (ref.watch(browseLocationProvider)) {
      null => null,
      BrowseLocation(pinned: true) => s.pinnedLocation,
      BrowseLocation() => s.myLocation,
    };
    return SScaffold(
      showAppBar: false,
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.xl,
        children: [
          if (user == null)
            const SignInPrompt()
          else
            SProfileHeader(
              title: user.name ?? user.email ?? s.accountTitle,
              subtitle: user.name == null ? null : user.email,
            ),
          SListGroup(
            title: s.appSection,
            separated: true,
            children: [
              SListTile(
                icon: SIcons.location,
                title: s.locationRow,
                value: place,
                onTap: () => context.push(Routes.location),
              ),
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
              SListTile(
                icon: SIcons.document,
                title: s.termsTitle,
                onTap: () => context.push(Routes.terms),
              ),
            ],
          ),
          // No question first: signing back in is one tap.
          if (user != null)
            SButton.dangerSecondary(
              label: s.logout,
              icon: SIcons.logout,
              expand: true,
              onPressed: ref.read(authRepositoryProvider).signOut,
            ),
        ],
      ),
    );
  }
}
