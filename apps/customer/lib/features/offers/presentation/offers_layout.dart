import 'dart:async';

import 'package:kernel/kernel.dart';

/// How a list of offers is shown: big [cards] with a photo across, or a
/// compact [list] of tiles, more to a screen.
enum OffersLayout { cards, list }

/// Where offers are listed, each keeping its own layout.
enum OffersPlace {
  /// Search and a home row's "See all": cards until the customer picks.
  lists('offers.layout', OffersLayout.cards),

  /// A store's page: its offers are all from one store, so tiles show
  /// more of them at once until the customer picks.
  store('store.offers.layout', OffersLayout.list);

  const OffersPlace(this._key, this._first);

  final String _key;
  final OffersLayout _first;
}

/// The layout the customer last picked for a [OffersPlace], remembered on
/// the phone.
class OffersLayoutController extends ViewModel<OffersLayout> {
  OffersLayoutController(this.place);

  final OffersPlace place;

  @override
  OffersLayout build() {
    unawaited(_load());
    return place._first;
  }

  Future<void> set(OffersLayout layout) async {
    state = layout;
    await ref.read(settingsStoreProvider).setString(place._key, layout.name);
  }

  Future<void> _load() async {
    final saved = await ref.read(settingsStoreProvider).getString(place._key);
    final layout = OffersLayout.values
        .where((layout) => layout.name == saved)
        .firstOrNull;
    if (layout != null && ref.mounted) state = layout;
  }
}

final offersLayoutProvider =
    NotifierProvider.family<OffersLayoutController, OffersLayout, OffersPlace>(
      OffersLayoutController.new,
    );
