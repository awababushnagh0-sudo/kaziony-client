import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/routes/routes.dart';
import '../../domain/store.dart';

/// Stores under a [title], each its logo over its name in a row that
/// scrolls sideways; tapping one opens its page. Nothing when there are
/// none.
class StoreLogoRow extends StatelessWidget {
  const StoreLogoRow({required this.title, required this.stores, super.key});

  final String title;
  final List<StoreSummary> stores;

  @override
  Widget build(BuildContext context) {
    if (stores.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.sm,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
          child: SSectionHeader(title),
        ),
        SCarousel.small(
          children: [
            for (final store in stores)
              SLogoTile(
                store.logoUrl,
                name: store.name,
                onTap: () => context.push(Routes.store(store.id)),
              ),
          ],
        ),
      ],
    );
  }
}
