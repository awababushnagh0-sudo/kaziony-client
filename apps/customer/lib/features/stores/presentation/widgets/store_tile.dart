import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/customer_localizations.dart';
import '../../../../core/routes/routes.dart';
import '../../../offers/presentation/offer_texts.dart';
import '../../domain/store.dart';

/// A store in a list that runs down the page: its logo, name, rating, kind,
/// area and how far, and how many offers it has now. Opens its page.
class StoreTile extends StatelessWidget {
  const StoreTile(this.store, {this.onOpen, this.trailing, super.key});

  final StoreSummary store;

  /// At the end, apart from the words (the heart that removes a favorite).
  final Widget? trailing;

  /// Told when it's opened, before the store's page shows.
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final details = [
      store.category.name(language),
      // A brand's places share its name: the area tells them apart.
      ?store.area,
      if (store.distanceKm case final km?) s.distance(km),
    ];
    return SCard(
      onTap: () {
        onOpen?.call();
        context.push(Routes.store(store.id));
      },
      child: Row(
        spacing: Space.md,
        children: [
          SImage(store.logoUrl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Space.xxs,
              children: [
                SText(store.name, weight: SFontWeight.semibold, maxLines: 1),
                Row(
                  spacing: Space.sm,
                  children: [
                    if (store.rating case final rating?)
                      SRating(
                        average: rating.average,
                        count: rating.count,
                        label: s.rating(rating),
                        small: true,
                      ),
                    Flexible(
                      child: SText(
                        details.join(' · '),
                        variant: TextVariant.caption,
                        color: SColor.textMuted,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                if (store.liveOfferCount > 0)
                  SBadge(
                    s.searchOffersNow(store.liveOfferCount),
                    tone: BadgeTone.success,
                  ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
