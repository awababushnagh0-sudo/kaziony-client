/// Every page's path.
abstract final class Routes {
  static const splash = '/';
  static const update = '/update';
  static const login = '/login';
  static const changePassword = '/change-password';
  static const home = '/home';
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
  static const newProduct = '$products/new';
  static String product(String id) => '$products/$id';

  /// Pages staff can't open: the API refuses them anyway.
  static bool ownerOnly(String location) =>
      location == products || location.startsWith('$products/');
}
