/// Every page's path.
abstract final class Routes {
  static const update = '/update';
  static const terms = '/terms';

  /// The first time: who we are, then where to show offers from, then
  /// signing in.
  static const welcome = '/welcome';
  static const welcomeLocation = '/welcome/location';
  static const welcomeMap = '/welcome/location/map';
  static const welcomeSignIn = '/welcome/sign-in';

  /// Opened from the app, back to where it was once done.
  static const signIn = '/sign-in';

  /// Where offers are shown from, with no saved place to switch to: where
  /// the phone is, or a spot on the map.
  static const location = '/location';
  static const locationMap = '/location/map';

  /// Where offers are shown from, to switch, change, delete or add one.
  static const places = '/places';
  static const addPlace = '/places/add';
  static const addPlaceMap = '/places/add/map';

  /// Moving a saved place: the map, from where it is now.
  static const placeMap = '/places/map';

  /// Every offer around, one sort or category ([offersQuery]): "See all".
  static const offers = '/offers';
  static String offersQuery({required String sort, String? categoryId}) => Uri(
    path: offers,
    queryParameters: {'sort': sort, 'category': ?categoryId},
  ).toString();

  static const offerPattern = '/offer/:offerId';
  static String offer(String offerId) => '/offer/$offerId';

  /// A store's page: its offers, branches, and following it.
  static const storePattern = '/store/:storeId';
  static String store(String storeId) => '/store/$storeId';

  /// The stores the customer saved, and the stars they gave: from the
  /// account tab.
  static const favorites = '/favorites';
  static const ratings = '/ratings';

  /// What the app told the customer: from the bell on home.
  static const notifications = '/notifications';

  /// A reservation's pickup code.
  static const bookingPattern = '/booking/:bookingId';
  static String booking(String bookingId) => '/booking/$bookingId';

  // The tabs.
  static const home = '/home';
  static const search = '/search';
  static const bookings = '/bookings';
  static const account = '/account';
}
