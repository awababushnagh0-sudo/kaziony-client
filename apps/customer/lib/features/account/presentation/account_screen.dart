import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/customer_illustrations.dart';
import '../../../core/widgets/sign_in_prompt.dart';
import '../../auth/domain/auth_repository.dart';
import '../../bookings/presentation/booking_texts.dart';
import '../../bookings/presentation/bookings_view_model.dart';
import '../../location/domain/browse_location.dart';
import '../../location/presentation/places_screen.dart';

/// Signed in, a greeting on a soft orange band, then the way to the
/// bookings (with how many wait), the favorite stores and the ratings
/// given. Signed out, the way to sign in. Then the app's settings, which
/// work signed out too.
class AccountScreen extends AppView {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final user = switch (ref.watch(sessionProvider)) {
      SignedIn(:final user) => user,
      _ => null,
    };
    if (user == null) {
      return const SScaffold(
        showAppBar: false,
        scrollable: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.xl,
          children: [SignInPrompt(), _Settings()],
        ),
      );
    }
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    final waiting = toPickUpAt(
      ref.watch(bookingsViewModel).value?.items ?? const [],
      now,
    ).length;
    final name = user.name?.trim();
    return SScaffold(
      showAppBar: false,
      scrollable: true,
      padded: false,
      underStatusBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.xl,
        children: [
          SProfileHeader.greeting(
            greeting: _greetingAt(s, now),
            // The first name is enough to be greeted by.
            name: name == null || name.isEmpty
                ? user.email ?? s.accountTitle
                : name.split(' ').first,
            subtitle: name == null || name.isEmpty ? null : user.email,
            illustration: CustomerIllustrations.bagHello,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Space.xl,
              children: [
                SShortcuts.pills([
                  ShortcutPill(
                    label: s.bookingsTitle,
                    icon: SIcons.bookings,
                    count: waiting,
                    onTap: () => context.go(Routes.bookings),
                  ),
                  ShortcutPill(
                    label: s.favoritesTitle,
                    icon: SIcons.favorites,
                    color: SColor.favorite,
                    onTap: () => context.push(Routes.favorites),
                  ),
                  ShortcutPill(
                    label: s.ratingsTitle,
                    icon: SIcons.ratings,
                    color: SColor.accent,
                    onTap: () => context.push(Routes.ratings),
                  ),
                ]),
                const _Settings(),
                SButton.dangerSecondary(
                  label: s.logout,
                  icon: SIcons.logout,
                  expand: true,
                  onPressed: () => _logout(context, ref),
                ),
                SButton.text(
                  label: s.deleteAccount,
                  onPressed: () => _deleteAccount(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Asks first: a stray tap shouldn't sign the customer out.
Future<void> _logout(BuildContext context, WidgetRef ref) async {
  final s = CustomerLocalizations.of(context);
  final confirmed = await SDialog.confirm(
    context,
    title: s.logoutTitle,
    message: s.logoutMessage,
    confirmLabel: s.logout,
    destructive: true,
  );
  if (confirmed) await ref.read(authRepositoryProvider).signOut();
}

/// Asks first, saying what goes with it: it can't be undone.
Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
  final s = CustomerLocalizations.of(context);
  final confirmed = await SDialog.confirm(
    context,
    title: s.deleteAccountTitle,
    message: s.deleteAccountMessage,
    confirmLabel: s.deleteAccountConfirm,
    destructive: true,
  );
  if (!confirmed) return;
  final result = await ref.read(authRepositoryProvider).deleteAccount();
  if (!context.mounted) return;
  switch (result) {
    case Ok():
      SSnack.success(context, s.accountDeleted);
    case Err(:final failure):
      SSnack.error(context, failureMessage(context, failure));
  }
}

/// "Good morning" until noon, then "good evening", as said in Libya.
String _greetingAt(CustomerLocalizations s, DateTime now) =>
    now.hour >= _morningFrom && now.hour < _eveningFrom
    ? s.greetingMorning
    : s.greetingEvening;

const _morningFrom = 4;
const _eveningFrom = 12;

/// Where offers are shown from, the language and look, and the terms.
class _Settings extends AppView {
  const _Settings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final stellar = StellarLocalizations.of(context);
    final place = switch (ref.watch(browseLocationProvider)) {
      null => null,
      BrowseLocation(:final name?) => name,
      BrowseLocation(pinned: true) => s.pinnedLocation,
      BrowseLocation() => s.myLocation,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.xl,
      children: [
        SListGroup(
          title: s.appSection,
          separated: true,
          children: [
            SListTile(
              icon: SIcons.location,
              title: s.locationRow,
              value: place,
              onTap: () => PlacesScreen.open(context, ref),
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
          ],
        ),
        SListGroup(
          title: s.aboutSection,
          separated: true,
          children: [
            SListTile(
              icon: SIcons.document,
              title: s.termsTitle,
              onTap: () => context.push(Routes.terms),
            ),
          ],
        ),
      ],
    );
  }
}
