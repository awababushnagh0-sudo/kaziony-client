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
  static const location = '/location';
  static const locationMap = '/location/map';

  // The tabs.
  static const home = '/home';
  static const search = '/search';
  static const bookings = '/bookings';
  static const favorites = '/favorites';
  static const account = '/account';
}
