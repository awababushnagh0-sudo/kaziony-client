/// Every page's path.
abstract final class Routes {
  static const splash = '/';
  static const update = '/update';
  static const login = '/login';
  static const changePassword = '/change-password';
  static const home = '/home';
  static const stores = '/stores';
  static String store(String id) => '$stores/$id';

  /// Everyone who books in the app.
  static const customers = '/customers';
  static String customer(String id) => '$customers/$id';
  static const users = '/users';
  static String user(String id) => '$users/$id';
  static const offers = '/offers';
  static const categories = '/categories';
  static const platform = '/platform';

  /// Customers' reports of problems with their bookings.
  static const reports = '/reports';

  /// What customers search for in the app.
  static const searches = '/searches';

  /// How the backend is doing: instances, traffic, errors, jobs, database.
  static const system = '/system';

  /// Who changed what in the dashboard.
  static const activity = '/activity';

  /// Pages only admins (and developers) open, not editors.
  static const adminOnly = {users, searches, activity};

  /// Pages only developers open: the system's insides.
  static const developerOnly = {system};

  /// Pages for signed-out users (and the update gate).
  static const entry = {splash, update, login, changePassword};
}
