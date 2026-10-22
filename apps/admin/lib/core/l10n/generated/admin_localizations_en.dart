// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'admin_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AdminLocalizationsEn extends AdminLocalizations {
  AdminLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Offers Admin';

  @override
  String get switchLanguage => 'العربية';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle =>
      'Welcome back. Sign in to manage stores and offers.';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Continue';

  @override
  String get wrongCredentials => 'Wrong email or password.';

  @override
  String get accountDisabled => 'This account is disabled.';

  @override
  String get sessionExpired => 'Your session ended. Please sign in again.';

  @override
  String get notAdminAccount =>
      'This dashboard is for our team\'s accounts only.';

  @override
  String get changePasswordTitle => 'Choose a new password';

  @override
  String get changePasswordSubtitle =>
      'You\'re using a temporary password. Choose your own to continue.';

  @override
  String get currentPasswordLabel => 'Temporary password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmPasswordLabel => 'Repeat the new password';

  @override
  String get savePasswordButton => 'Save and continue';

  @override
  String get wrongCurrentPassword => 'The temporary password is wrong.';

  @override
  String get passwordChanged => 'Password changed.';

  @override
  String get logout => 'Log out';

  @override
  String get navHome => 'Home';

  @override
  String get navStores => 'Stores';

  @override
  String get navUsers => 'Users';

  @override
  String get navOffers => 'Offers';

  @override
  String get navCategories => 'Categories';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get comingSoonMessage => 'This page is part of the next steps.';

  @override
  String get statsStores => 'Stores';

  @override
  String statsStoresDetail(int active) {
    return '$active active';
  }

  @override
  String get statsLiveOffers => 'Live offers';

  @override
  String statsLiveOffersDetail(int total) {
    return '$total posted in total';
  }

  @override
  String get statsCustomers => 'Customers';

  @override
  String statsCustomersDetail(int count) {
    return '$count new in the last 7 days';
  }

  @override
  String get statsClaims => 'Claims, last 7 days';

  @override
  String statsClaimsDetail(int percent) {
    return '$percent% of finished claims were picked up';
  }

  @override
  String get statsClaimsNoneFinished => 'No finished claims yet';

  @override
  String get refresh => 'Refresh';

  @override
  String get appSubtitle => 'Admin dashboard';

  @override
  String get storesTitle => 'Stores';

  @override
  String storesTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stores',
      one: '1 store',
    );
    return '$_temp0';
  }

  @override
  String get storesSearch => 'Search by name';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterDisabled => 'Disabled';

  @override
  String get columnName => 'Name';

  @override
  String get columnCategory => 'Category';

  @override
  String get columnBranches => 'Branches';

  @override
  String get columnStatus => 'Status';

  @override
  String get columnAdded => 'Added';

  @override
  String get storeActive => 'Active';

  @override
  String get storeDisabled => 'Disabled';

  @override
  String get storesEmpty => 'No stores yet';

  @override
  String get storesEmptyMessage =>
      'Add the first store and give its owner their login.';

  @override
  String get listNoResults => 'No matches';

  @override
  String get listNoResultsMessage => 'Try another search or clear the filters.';

  @override
  String pageOf(int page, int pages) {
    return 'Page $page of $pages';
  }

  @override
  String get previousPage => 'Previous page';

  @override
  String get nextPage => 'Next page';

  @override
  String get addStore => 'Add store';

  @override
  String get addStoreTitle => 'New store';

  @override
  String get createStore => 'Create store';

  @override
  String get sectionStore => 'Store';

  @override
  String get sectionBranch => 'First branch';

  @override
  String get sectionOwner => 'Owner account';

  @override
  String get storeName => 'Store name';

  @override
  String get storeCategory => 'Category';

  @override
  String get storeCategoryHint => 'Choose';

  @override
  String get storePhone => 'Store phone';

  @override
  String get storeEmail => 'Store email';

  @override
  String get storeDescription => 'Description';

  @override
  String get tabDetails => 'Details';

  @override
  String get tabContact => 'Contact';

  @override
  String get storeFacebook => 'Facebook';

  @override
  String get storeInstagram => 'Instagram';

  @override
  String get storeTeam => 'Team';

  @override
  String get save => 'Save';

  @override
  String get notSaved => 'Not saved';

  @override
  String get savedDone => 'Saved';

  @override
  String get discardChangesTitle => 'Discard your changes?';

  @override
  String get discardChangesMessage =>
      'Your changes haven\'t been saved. Leave without saving?';

  @override
  String get discardChanges => 'Discard';

  @override
  String get actions => 'Actions';

  @override
  String get disableStore => 'Disable store';

  @override
  String get disableStoreHint => 'Hide it from customers';

  @override
  String get enableStore => 'Enable store';

  @override
  String get deleteStore => 'Delete store';

  @override
  String get deleteStoreHint => 'Only for stores without offers';

  @override
  String disableStoreTitle(String store) {
    return 'Disable $store?';
  }

  @override
  String get disableStoreMessage =>
      'Customers won\'t see the store or its offers, and its team can\'t post new ones. You can enable it again at any time.';

  @override
  String deleteStoreTitle(String store) {
    return 'Delete $store?';
  }

  @override
  String get deleteStoreMessage =>
      'The store, its branches and its products are deleted for good. Its team keeps their accounts.';

  @override
  String get storeDisabledDone => 'Store disabled';

  @override
  String get storeEnabledDone => 'Store enabled';

  @override
  String get storeDeletedDone => 'Store deleted';

  @override
  String get storeHasOffers =>
      'This store has offers, so it can\'t be deleted. Disable it instead.';

  @override
  String get branchName => 'Branch name';

  @override
  String get branchNameHint => 'e.g. Hay Al Andalus';

  @override
  String get branchCity => 'City';

  @override
  String get cityTripoli => 'Tripoli';

  @override
  String get branchArea => 'Area';

  @override
  String get branchAddress => 'Address';

  @override
  String get branchLocation => 'Location';

  @override
  String get branchLocationHelp =>
      'Paste a Google Maps link, or coordinates like 32.8872, 13.1913';

  @override
  String get invalidLocation =>
      'Couldn\'t read a location from this link. Paste a Google Maps link or the coordinates.';

  @override
  String get locationOutsideLibya => 'This location is outside Libya.';

  @override
  String locationFound(String latitude, String longitude) {
    return 'Location found: $latitude, $longitude';
  }

  @override
  String get locationUnchecked =>
      'Couldn\'t check the link. Check your connection and try again.';

  @override
  String get ownerName => 'Owner name';

  @override
  String get ownerPhone => 'Owner phone';

  @override
  String get ownerPhoneHelp =>
      'The owner logs in to the store app with this number.';

  @override
  String get phoneTakenByCustomer =>
      'This number belongs to a customer account. Use another number for the store owner.';

  @override
  String get categoriesFailed => 'Couldn\'t load the categories.';

  @override
  String get storeCreatedTitle => 'Store created';

  @override
  String storeCreatedMessage(String store) {
    return 'Give these details to the owner of $store. They will choose their own password when they first log in.';
  }

  @override
  String get loginPhone => 'Login phone';

  @override
  String get temporaryPassword => 'Temporary password';

  @override
  String get passwordShownOnce =>
      'The password is shown only now. Copy it before closing.';

  @override
  String ownerLinkedMessage(String store) {
    return 'This number already had a store account, so it was added as the owner of $store. They log in with their current password.';
  }

  @override
  String get done => 'Done';

  @override
  String get usersTitle => 'Users';

  @override
  String usersTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users',
      one: '1 user',
    );
    return '$_temp0';
  }

  @override
  String get usersSearch => 'Search by name or email';

  @override
  String get usersEmpty => 'No users yet';

  @override
  String get usersEmptyMessage =>
      'Add the people on your team who use this dashboard.';

  @override
  String get filterAdmins => 'Admins';

  @override
  String get filterEditors => 'Editors';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleEditor => 'Editor';

  @override
  String get columnEmail => 'Email';

  @override
  String get columnRole => 'Role';

  @override
  String get columnLastLogin => 'Last login';

  @override
  String get neverLoggedIn => 'Never';

  @override
  String get userActive => 'Active';

  @override
  String get userDisabled => 'Disabled';

  @override
  String get addUser => 'Add user';

  @override
  String get addUserTitle => 'Add a user';

  @override
  String get userName => 'Name';

  @override
  String get userEmail => 'Email';

  @override
  String get userEmailHelp => 'They log in with it.';

  @override
  String get userRole => 'Role';

  @override
  String get userRoleHelp =>
      'Editors can add and edit, but can\'t delete or manage users.';

  @override
  String get emailTaken => 'This email already has an account.';

  @override
  String get userCreatedTitle => 'User added';

  @override
  String userCreatedMessage(String name) {
    return 'Give these details to $name. They will choose their own password when they first log in.';
  }

  @override
  String get loginEmail => 'Login email';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordHint => 'Give them a new temporary password';

  @override
  String resetPasswordTitle(String name) {
    return 'Reset $name\'s password?';
  }

  @override
  String get resetPasswordMessage =>
      'They\'ll get a new temporary password and be logged out everywhere. Their current password stops working.';

  @override
  String get newPasswordTitle => 'New password';

  @override
  String newPasswordMessage(String name) {
    return 'Give this to $name. They will choose their own password when they next log in.';
  }

  @override
  String get disableUser => 'Disable user';

  @override
  String get disableUserHint => 'Log them out and stop them logging in';

  @override
  String get enableUser => 'Enable user';

  @override
  String disableUserTitle(String name) {
    return 'Disable $name?';
  }

  @override
  String get disableUserMessage =>
      'They\'re logged out everywhere and can\'t log in until you enable them again.';

  @override
  String get userDisabledDone => 'User disabled';

  @override
  String get userEnabledDone => 'User enabled';
}
