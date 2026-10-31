import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// The pictures only this app shows, in its own `assets/illustrations`.
/// Shown with `SIllustration`, like stellar's own.
enum PartnerIllustrations implements Illustration {
  /// The logo and the brand's name, with "for stores" on a shop sign
  /// hanging from it: the stores' app. It has words, so it's drawn in each
  /// language.
  partnerMark('partner_mark', Size(164, 71), arabicSize: Size(126, 75)),

  /// A shop counter with the day's offers and a phone showing a pickup
  /// code, on the sign-in page. Drawn at 400 by 300; shown a little
  /// smaller, so it leaves room for the form on big phones too.
  signInHero('sign_in_hero', Size(340, 255)),

  /// A shop's pin at the end of a dotted path, with a clock: customers on
  /// their way. The four below are on home's numbers.
  onTheWay('on_the_way', Size(52, 52)),

  /// A bag with a check: picked up.
  pickedUp('picked_up', Size(52, 52)),

  /// A sleeping bag: reservations no one came for.
  notPickedUp('not_picked_up', Size(52, 52)),

  /// A price tag: offers customers can claim now.
  liveOffers('live_offers', Size(52, 52)),

  /// A shop front with an "i" on its sign: the store's details. The three
  /// below are on the profile's shortcuts.
  storeInfo('store_info', Size(56, 56)),

  /// A folded map with two pins: the store's branches.
  branches('branches', Size(56, 56)),

  /// Two people, the owner in front: the store's team.
  team('team', Size(56, 56)),

  /// A price tag beside an empty one drawn in dashes, and a plus: no
  /// offers yet. The three below are on empty pages (`SEmptyView`).
  noOffers('no_offers', Size(140, 104)),

  /// An open box with nothing in it: no products yet.
  noProducts('no_products', Size(140, 104)),

  /// The brand bag on the counter beside a clock: no one on their way.
  noPickups('no_pickups', Size(140, 104)),

  /// Two empty tags in dashes behind a filter: no offers of this kind.
  noOffersHere('no_offers_here', Size(140, 104)),

  /// An archive box with its lid lifted, nothing inside: none archived.
  noArchived('no_archived', Size(140, 104)),

  /// A magnifier with a cross over a list: nothing matches the search.
  noResults('no_results', Size(140, 104));

  const PartnerIllustrations(this.file, this.size, {this.arabicSize});

  @override
  final String file;
  @override
  final Size size;
  @override
  final Size? arabicSize;

  @override
  String? get package => null;
}
