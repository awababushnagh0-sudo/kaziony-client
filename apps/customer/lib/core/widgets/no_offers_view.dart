import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/customer_localizations.dart';
import '../routes/routes.dart';
import 'customer_illustrations.dart';

/// No offers around the place they're shown from, the same wherever a list
/// of offers comes back empty: the place's picture, that stores post
/// during the day, and the way to change the place.
class NoOffersView extends StatelessWidget {
  const NoOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return SEmptyView(
      illustration: CustomerIllustrations.location,
      title: s.noOffersTitle,
      message: s.noOffersMessage,
      actionLabel: s.changePlace,
      onAction: () => context.push(Routes.location),
    );
  }
}
