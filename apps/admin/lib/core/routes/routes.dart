/// Every page's path.
abstract final class Routes {
  static const splash = '/';
  static const update = '/update';
  static const login = '/login';
  static const changePassword = '/change-password';
  static const home = '/home';
  static const stores = '/stores';
  static const users = '/users';
  static const offers = '/offers';
  static const categories = '/categories';

  /// Pages for signed-out users (and the update gate).
  static const entry = {splash, update, login, changePassword};
}
