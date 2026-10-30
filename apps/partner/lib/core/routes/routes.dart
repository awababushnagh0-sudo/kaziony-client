/// Every page's path.
abstract final class Routes {
  static const splash = '/';
  static const update = '/update';
  static const login = '/login';
  static const changePassword = '/change-password';
  static const home = '/home';
  static const offers = '/offers';
  static const scan = '/scan';
  static const products = '/products';
  static const profile = '/profile';
  static const chooseStore = '/choose-store';
  static const noStore = '/no-store';

  // Opened from Profile, over the tabs.
  static const storeInfo = '/store-info';
  static const editStoreInfo = '/store-info/edit';
  static const branches = '/branches';
  static const team = '/team';
  static const password = '/password';
  static const about = '/about';
  static const terms = '/terms';
  static const newProduct = '$products/new';
  static String product(String id) => '$products/$id';
  static String editProduct(String id) => '${product(id)}/edit';

  /// Posting an offer starts with its product.
  static const chooseOfferProduct = '$offers/new';
  static String newOffer(String productId, {String? from}) =>
      '$chooseOfferProduct/$productId${from == null ? '' : '?from=$from'}';
  static String offer(String id) => '$offers/$id';
  static String editOffer(String id) => '${offer(id)}/edit';

  // The counter, over the Scan tab.
  static const typeCode = '$scan/type';
  static const pickups = '/pickups';

  /// [fromList]: opened by tapping a name, not by the customer's code, so
  /// the page asks before confirming.
  static String claim(String code, {bool fromList = false}) =>
      fromList ? '/claims/$code?from=list' : '/claims/$code';

  /// Pages staff can't open: the API refuses them anyway. Staff see
  /// offers, but don't post or change them.
  static bool ownerOnly(String location) =>
      location == products ||
      location.startsWith('$products/') ||
      location == chooseOfferProduct ||
      location.startsWith('$chooseOfferProduct/') ||
      (location.startsWith('$offers/') && location.endsWith('/edit'));
}
