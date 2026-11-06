import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/customer_illustrations.dart';
import '../../../core/widgets/sign_in_prompt.dart';
import 'stores_view_model.dart';
import 'widgets/store_tile.dart';
import 'widgets/store_tile_skeleton.dart';

/// The Favorites tab: the stores the customer saved with the heart on a
/// store's page, the last saved first, each with how many offers it has
/// now. Signed out, the way to sign in.
class FavoritesScreen extends AppView {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    if (ref.watch(sessionProvider) is! SignedIn) {
      return SScaffold(
        title: s.favoritesTitle,
        body: SignInPrompt(
          title: s.storeFavoriteSignInTitle,
          message: s.storeFavoriteSignInMessage,
        ),
      );
    }
    return SScaffold(
      title: s.favoritesTitle,
      padded: false,
      body: const _Stores(),
    );
  }
}

class _Stores extends AppView {
  const _Stores();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    return SAsyncView(
      value: ref.watch(followedStoresProvider),
      onRetry: () => ref.invalidate(followedStoresProvider),
      loading: const Padding(
        padding: EdgeInsets.all(Space.lg),
        child: StoreTilesSkeleton(count: 4),
      ),
      builder: (context, stores) {
        if (stores.isEmpty) {
          return SEmptyView(
            illustration: CustomerIllustrations.favorites,
            title: s.favoritesEmptyTitle,
            message: s.favoritesEmptyMessage,
            actionLabel: s.browseOffers,
            onAction: () => context.go(Routes.home),
          );
        }
        return SSliverView(
          onRefresh: () => ref.refresh(followedStoresProvider.future),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(Space.lg),
              sliver: SliverList.separated(
                itemCount: stores.length,
                itemBuilder: (_, i) => StoreTile(stores[i]),
                separatorBuilder: (_, _) => const Gap(Space.sm),
              ),
            ),
          ],
        );
      },
    );
  }
}
