/// Every page's path.
abstract final class Routes {
  static const splash = '/';
  static const update = '/update';
  static const login = '/login';
  static const changePassword = '/change-password';
  static const home = '/home';
  static const stores = '/stores';
  static String store(String id) => '$stores/$id';
  static const users = '/users';
  static String user(String id) => '$users/$id';
  static const offers = '/offers';
  static const categories = '/categories';

  /// Pages only admins open, not editors.
  static const adminOnly = {users};

  /// Pages for signed-out users (and the update gate).
  static const entry = {splash, update, login, changePassword};
}
