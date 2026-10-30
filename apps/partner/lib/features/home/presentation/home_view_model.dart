import 'package:kernel/kernel.dart';

import '../../counter/domain/claim.dart';
import '../../offers/domain/offer.dart';
import '../../store/domain/current_store.dart';
import '../domain/store_stats.dart';

/// Everything the home page shows, loaded together.
class Home {
  const Home({
    required this.stats,
    required this.reservations,
    required this.liveOffers,
  });

  /// Rows each list shows; "See all" opens the rest.
  static const shown = 3;

  final StoreStats stats;

  /// The first reservations, soonest to expire first. The server may not
  /// have ended the last few that ran out yet.
  final List<Claim> reservations;

  /// Offers customers can claim now, ending soonest first.
  final List<Offer> liveOffers;

  /// The customers still on their way at [now].
  List<Claim> onTheWayAt(DateTime now) =>
      reservations.where((claim) => claim.isHeldAt(now)).take(shown).toList();

  int get runningOut => liveOffers.where((offer) => offer.isRunningOut).length;
}

/// Today's numbers, the next customers and how the live offers sell.
class HomeViewModel extends AsyncViewModel<Home> {
  // A few more than shown, for any that ran out before the server noticed.
  static const _reservationsAsked = Home.shown + 2;

  // Enough to count the offers running out; stores have a handful live.
  static const _offersAsked = 50;

  @override
  Future<Home> build() => _load(ref.watch(currentStoreProvider)?.storeId);

  /// Loads again behind what's shown. Returns what went wrong, or null.
  Future<AppFailure?> refresh() async {
    try {
      final home = await _load(ref.read(currentStoreProvider)?.storeId);
      if (ref.mounted) state = AsyncData(home);
      return null;
    } on AppFailure catch (failure) {
      return failure;
    }
  }

  Future<Home> _load(String? storeId) async {
    if (storeId == null) throw const NotFoundFailure();
    final (stats, reservations, offers) = await (
      ref.read(statsRepositoryProvider).get(storeId),
      ref
          .read(claimRepositoryProvider)
          .upcoming(storeId, page: 1, pageSize: _reservationsAsked),
      ref
          .read(offerRepositoryProvider)
          .list(
            storeId,
            page: 1,
            pageSize: _offersAsked,
            status: OfferStatus.active,
          ),
    ).wait;
    return Home(
      stats: stats.valueOrThrow,
      reservations: reservations.valueOrThrow.items,
      liveOffers:
          offers.valueOrThrow.items
              .where((offer) => offer.state == OfferState.live)
              .toList()
            ..sort((a, b) => a.endsAt.compareTo(b.endsAt)),
    );
  }
}

final homeViewModel = AsyncNotifierProvider.autoDispose<HomeViewModel, Home>(
  HomeViewModel.new,
);
