import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../domain/product.dart';

/// A product in a list, as a card like the Offers tab's: its photo, name
/// and regular price.
class ProductTile extends StatelessWidget {
  const ProductTile({required this.product, required this.onTap, super.key});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SDealTile(
    imageUrl: product.thumbUrl,
    title: product.title,
    price: formatPrice(
      product.regularPrice,
      languageCode: Localizations.localeOf(context).languageCode,
    ),
    bordered: true,
    onTap: onTap,
  );
}
