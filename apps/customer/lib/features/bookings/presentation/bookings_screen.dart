import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/coming_soon_screen.dart';

/// The customer's bookings; signed out, the way to sign in to see them.
class BookingsScreen extends AppView {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    if (ref.watch(sessionProvider) is SignedIn) {
      return ComingSoonScreen(title: s.bookingsTitle);
    }
    return SScaffold(
      title: s.bookingsTitle,
      body: SEmptyView(
        icon: SIcons.bookings,
        title: s.bookingsSignedOutTitle,
        message: s.bookingsSignedOutMessage,
        actionLabel: s.signInAction,
        actionIcon: SIcons.user,
        onAction: () => context.push(Routes.signIn),
      ),
    );
  }
}
