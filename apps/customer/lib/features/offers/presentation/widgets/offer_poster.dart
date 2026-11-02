import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/customer_localizations.dart';
import '../../../../core/routes/routes.dart';
import '../../domain/offer.dart';
import '../offer_texts.dart';

/// An offer on the home page and in lists; opens its page.
class OfferPoster extends AppView {
  const OfferPoster(this.offer, {this.inRow = false, super.key});

  final Offer offer;

  /// One of a row that scrolls sideways.
  final bool inRow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    return SDealPoster(
      title: offer.title,
      storeName: offer.store.name,
      storeLogoUrl: offer.store.logoUrl,
      imageUrl: offer.imageUrl,
      price: s.price(context, offer.offerPrice),
      originalPrice: s.price(context, offer.originalPrice),
      discountLabel: s.discountOff(offer.discountPercent),
      stockLabel: s.stock(offer),
      stockHot: offer.almostGone,
      details: s.details(context, offer, now),
      inRow: inRow,
      onTap: () => context.push(Routes.offer(offer.id)),
    );
  }
}
