import 'dart:async';

import 'package:kernel/kernel.dart';

/// How a list of offers is shown: big [cards] with a photo across, or a
/// compact [list] of tiles, more to a screen.
enum OffersLayout { cards, list }

/// The layout the customer last picked, remembered on the phone. Cards
/// until they pick.
class OffersLayoutController extends ViewModel<OffersLayout> {
  static const _key = 'offers.layout';

  @override
  OffersLayout build() {
    unawaited(_load());
    return OffersLayout.cards;
  }

  Future<void> set(OffersLayout layout) async {
    state = layout;
    await ref.read(settingsStoreProvider).setString(_key, layout.name);
  }

  Future<void> _load() async {
    final saved = await ref.read(settingsStoreProvider).getString(_key);
    final layout = OffersLayout.values
        .where((layout) => layout.name == saved)
        .firstOrNull;
    if (layout != null && ref.mounted) state = layout;
  }
}

final offersLayoutProvider =
    NotifierProvider<OffersLayoutController, OffersLayout>(
      OffersLayoutController.new,
    );
