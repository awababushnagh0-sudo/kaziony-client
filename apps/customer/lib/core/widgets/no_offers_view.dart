import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/location/presentation/places_screen.dart';
import '../l10n/generated/customer_localizations.dart';
import 'customer_illustrations.dart';

/// No offers around the place they're shown from, the same wherever a list
/// of offers comes back empty: the place's picture, that stores post
/// during the day, and the way to change the place.
class NoOffersView extends AppView {
  const NoOffersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    return SEmptyView(
      illustration: CustomerIllustrations.location,
      title: s.noOffersTitle,
      message: s.noOffersMessage,
      actionLabel: s.changePlace,
      onAction: () => PlacesScreen.open(context, ref),
    );
  }
}
