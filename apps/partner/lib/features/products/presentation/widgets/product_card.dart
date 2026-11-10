import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import '../../domain/product.dart';

/// A product in the Products tab's grid: its photo (or a word asking for
/// one) with the offer to post from it on its corner, and its name and
/// regular price under it. No outline: the photo is the card's edge.
/// [onPostOffer] is null for an archived product: it's restored first,
/// from its page.
class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.onTap,
    this.onPostOffer,
    super.key,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onPostOffer;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final onPostOffer = this.onPostOffer;
    return SCard.plain(
      padded: false,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              SImage.wide(
                product.thumbUrl,
                ratio: SImageRatio.card,
                missing: s.productAddPhoto,
              ),
              if (onPostOffer != null)
                PositionedDirectional(
                  end: Space.sm,
                  bottom: Space.sm,
                  child: SButton.onPhoto(
                    label: s.postOffer,
                    icon: SIcons.offers,
                    onPressed: onPostOffer,
                  ),
                ),
            ],
          ),
          Padding(
            // A little in from the photo's rounded corners, and room under
            // the price before the next line of photos.
            padding: const EdgeInsets.fromLTRB(
              Space.xs,
              Space.sm,
              Space.xs,
              Space.xs,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Space.xxs,
              children: [
                SText(product.title, weight: SFontWeight.semibold, maxLines: 2),
                SText(
                  formatPrice(
                    product.regularPrice,
                    languageCode: Localizations.localeOf(context).languageCode,
                  ),
                  weight: SFontWeight.bold,
                  color: SColor.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
