import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'admin_localizations_ar.dart';
import 'admin_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AdminLocalizations
/// returned by `AdminLocalizations.of(context)`.
///
/// Applications need to include `AdminLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/admin_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AdminLocalizations.localizationsDelegates,
///   supportedLocales: AdminLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AdminLocalizations.supportedLocales
/// property.
abstract class AdminLocalizations {
  AdminLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AdminLocalizations of(BuildContext context) {
    return Localizations.of<AdminLocalizations>(context, AdminLocalizations)!;
  }

  static const LocalizationsDelegate<AdminLocalizations> delegate =
      _AdminLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers Admin'**
  String get appTitle;

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get switchLanguage;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back. Sign in to manage stores and offers.'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get loginButton;

  /// No description provided for @wrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password.'**
  String get wrongCredentials;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account is disabled.'**
  String get accountDisabled;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session ended. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @notAdminAccount.
  ///
  /// In en, this message translates to:
  /// **'This dashboard is for our team\'s accounts only.'**
  String get notAdminAccount;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re using a temporary password. Choose your own to continue.'**
  String get changePasswordSubtitle;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Temporary password'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat the new password'**
  String get confirmPasswordLabel;

  /// No description provided for @savePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get savePasswordButton;

  /// No description provided for @wrongCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'The temporary password is wrong.'**
  String get wrongCurrentPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed.'**
  String get passwordChanged;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navStores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get navStores;

  /// No description provided for @navUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get navUsers;

  /// No description provided for @navOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get navOffers;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'This page is part of the next steps.'**
  String get comingSoonMessage;

  /// No description provided for @statsStores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get statsStores;

  /// No description provided for @statsStoresDetail.
  ///
  /// In en, this message translates to:
  /// **'{active} active'**
  String statsStoresDetail(int active);

  /// No description provided for @statsLiveOffers.
  ///
  /// In en, this message translates to:
  /// **'Live offers'**
  String get statsLiveOffers;

  /// No description provided for @statsLiveOffersDetail.
  ///
  /// In en, this message translates to:
  /// **'{total} posted in total'**
  String statsLiveOffersDetail(int total);

  /// No description provided for @statsCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get statsCustomers;

  /// No description provided for @statsCustomersDetail.
  ///
  /// In en, this message translates to:
  /// **'{count} new in the last 7 days'**
  String statsCustomersDetail(int count);

  /// No description provided for @statsClaims.
  ///
  /// In en, this message translates to:
  /// **'Claims, last 7 days'**
  String get statsClaims;

  /// No description provided for @statsClaimsDetail.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of finished claims were picked up'**
  String statsClaimsDetail(int percent);

  /// No description provided for @statsClaimsNoneFinished.
  ///
  /// In en, this message translates to:
  /// **'No finished claims yet'**
  String get statsClaimsNoneFinished;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Admin dashboard'**
  String get appSubtitle;

  /// No description provided for @storesTitle.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get storesTitle;

  /// No description provided for @storesTotal.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 store} other{{count} stores}}'**
  String storesTotal(int count);

  /// No description provided for @storesSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get storesSearch;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filterActive;

  /// No description provided for @filterDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get filterDisabled;

  /// No description provided for @columnName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get columnName;

  /// No description provided for @columnCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get columnCategory;

  /// No description provided for @columnBranches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get columnBranches;

  /// No description provided for @columnStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get columnStatus;

  /// No description provided for @columnAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get columnAdded;

  /// No description provided for @storeActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get storeActive;

  /// No description provided for @storeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get storeDisabled;

  /// No description provided for @storesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stores yet'**
  String get storesEmpty;

  /// No description provided for @storesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add the first store and give its owner their login.'**
  String get storesEmptyMessage;

  /// No description provided for @listNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get listNoResults;

  /// No description provided for @listNoResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try another search or clear the filters.'**
  String get listNoResultsMessage;

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages}'**
  String pageOf(int page, int pages);

  /// No description provided for @previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get nextPage;

  /// No description provided for @addStore.
  ///
  /// In en, this message translates to:
  /// **'Add store'**
  String get addStore;

  /// No description provided for @addStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'New store'**
  String get addStoreTitle;

  /// No description provided for @createStore.
  ///
  /// In en, this message translates to:
  /// **'Create store'**
  String get createStore;

  /// No description provided for @sectionStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get sectionStore;

  /// No description provided for @sectionBranch.
  ///
  /// In en, this message translates to:
  /// **'First branch'**
  String get sectionBranch;

  /// No description provided for @sectionOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner account'**
  String get sectionOwner;

  /// No description provided for @storeName.
  ///
  /// In en, this message translates to:
  /// **'Store name'**
  String get storeName;

  /// No description provided for @storeCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get storeCategory;

  /// No description provided for @storeCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get storeCategoryHint;

  /// No description provided for @storePhone.
  ///
  /// In en, this message translates to:
  /// **'Store phone'**
  String get storePhone;

  /// No description provided for @storeEmail.
  ///
  /// In en, this message translates to:
  /// **'Store email'**
  String get storeEmail;

  /// No description provided for @storeDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get storeDescription;

  /// No description provided for @tabDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get tabDetails;

  /// No description provided for @tabContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get tabContact;

  /// No description provided for @storeFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get storeFacebook;

  /// No description provided for @storeInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get storeInstagram;

  /// No description provided for @storeTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get storeTeam;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @notSaved.
  ///
  /// In en, this message translates to:
  /// **'Not saved'**
  String get notSaved;

  /// No description provided for @savedDone.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedDone;

  /// No description provided for @discardChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard your changes?'**
  String get discardChangesTitle;

  /// No description provided for @discardChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'Your changes haven\'t been saved. Leave without saving?'**
  String get discardChangesMessage;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardChanges;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @disableStore.
  ///
  /// In en, this message translates to:
  /// **'Disable store'**
  String get disableStore;

  /// No description provided for @disableStoreHint.
  ///
  /// In en, this message translates to:
  /// **'Hide it from customers'**
  String get disableStoreHint;

  /// No description provided for @enableStore.
  ///
  /// In en, this message translates to:
  /// **'Enable store'**
  String get enableStore;

  /// No description provided for @deleteStore.
  ///
  /// In en, this message translates to:
  /// **'Delete store'**
  String get deleteStore;

  /// No description provided for @deleteStoreHint.
  ///
  /// In en, this message translates to:
  /// **'Only for stores without offers'**
  String get deleteStoreHint;

  /// No description provided for @disableStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable {store}?'**
  String disableStoreTitle(String store);

  /// No description provided for @disableStoreMessage.
  ///
  /// In en, this message translates to:
  /// **'Customers won\'t see the store or its offers, and its team can\'t post new ones. You can enable it again at any time.'**
  String get disableStoreMessage;

  /// No description provided for @deleteStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {store}?'**
  String deleteStoreTitle(String store);

  /// No description provided for @deleteStoreMessage.
  ///
  /// In en, this message translates to:
  /// **'The store, its branches and its products are deleted for good. Its team keeps their accounts.'**
  String get deleteStoreMessage;

  /// No description provided for @storeDisabledDone.
  ///
  /// In en, this message translates to:
  /// **'Store disabled'**
  String get storeDisabledDone;

  /// No description provided for @storeEnabledDone.
  ///
  /// In en, this message translates to:
  /// **'Store enabled'**
  String get storeEnabledDone;

  /// No description provided for @storeDeletedDone.
  ///
  /// In en, this message translates to:
  /// **'Store deleted'**
  String get storeDeletedDone;

  /// No description provided for @storeHasOffers.
  ///
  /// In en, this message translates to:
  /// **'This store has offers, so it can\'t be deleted. Disable it instead.'**
  String get storeHasOffers;

  /// No description provided for @branchName.
  ///
  /// In en, this message translates to:
  /// **'Branch name'**
  String get branchName;

  /// No description provided for @branchNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hay Al Andalus'**
  String get branchNameHint;

  /// No description provided for @branchCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get branchCity;

  /// No description provided for @cityTripoli.
  ///
  /// In en, this message translates to:
  /// **'Tripoli'**
  String get cityTripoli;

  /// No description provided for @branchArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get branchArea;

  /// No description provided for @branchAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get branchAddress;

  /// No description provided for @branchLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get branchLocation;

  /// No description provided for @branchLocationHelp.
  ///
  /// In en, this message translates to:
  /// **'Paste a Google Maps link, or coordinates like 32.8872, 13.1913'**
  String get branchLocationHelp;

  /// No description provided for @invalidLocation.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read a location from this link. Paste a Google Maps link or the coordinates.'**
  String get invalidLocation;

  /// No description provided for @locationOutsideLibya.
  ///
  /// In en, this message translates to:
  /// **'This location is outside Libya.'**
  String get locationOutsideLibya;

  /// No description provided for @locationFound.
  ///
  /// In en, this message translates to:
  /// **'Location found: {latitude}, {longitude}'**
  String locationFound(String latitude, String longitude);

  /// No description provided for @locationUnchecked.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check the link. Check your connection and try again.'**
  String get locationUnchecked;

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Owner name'**
  String get ownerName;

  /// No description provided for @ownerPhone.
  ///
  /// In en, this message translates to:
  /// **'Owner phone'**
  String get ownerPhone;

  /// No description provided for @ownerPhoneHelp.
  ///
  /// In en, this message translates to:
  /// **'The owner logs in to the store app with this number.'**
  String get ownerPhoneHelp;

  /// No description provided for @phoneTakenByCustomer.
  ///
  /// In en, this message translates to:
  /// **'This number belongs to a customer account. Use another number for the store owner.'**
  String get phoneTakenByCustomer;

  /// No description provided for @categoriesFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the categories.'**
  String get categoriesFailed;

  /// No description provided for @storeCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Store created'**
  String get storeCreatedTitle;

  /// No description provided for @storeCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Give these details to the owner of {store}. They will choose their own password when they first log in.'**
  String storeCreatedMessage(String store);

  /// No description provided for @loginPhone.
  ///
  /// In en, this message translates to:
  /// **'Login phone'**
  String get loginPhone;

  /// No description provided for @temporaryPassword.
  ///
  /// In en, this message translates to:
  /// **'Temporary password'**
  String get temporaryPassword;

  /// No description provided for @passwordShownOnce.
  ///
  /// In en, this message translates to:
  /// **'The password is shown only now. Copy it before closing.'**
  String get passwordShownOnce;

  /// No description provided for @ownerLinkedMessage.
  ///
  /// In en, this message translates to:
  /// **'This number already had a store account, so it was added as the owner of {store}. They log in with their current password.'**
  String ownerLinkedMessage(String store);

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @usersTitle.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersTitle;

  /// No description provided for @usersTotal.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 user} other{{count} users}}'**
  String usersTotal(int count);

  /// No description provided for @usersSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email'**
  String get usersSearch;

  /// No description provided for @usersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No users yet'**
  String get usersEmpty;

  /// No description provided for @usersEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add the people on your team who use this dashboard.'**
  String get usersEmptyMessage;

  /// No description provided for @filterAdmins.
  ///
  /// In en, this message translates to:
  /// **'Admins'**
  String get filterAdmins;

  /// No description provided for @filterEditors.
  ///
  /// In en, this message translates to:
  /// **'Editors'**
  String get filterEditors;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleEditor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get roleEditor;

  /// No description provided for @columnEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get columnEmail;

  /// No description provided for @columnRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get columnRole;

  /// No description provided for @columnLastLogin.
  ///
  /// In en, this message translates to:
  /// **'Last login'**
  String get columnLastLogin;

  /// No description provided for @neverLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get neverLoggedIn;

  /// No description provided for @userActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get userActive;

  /// No description provided for @userDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get userDisabled;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get addUser;

  /// No description provided for @addUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a user'**
  String get addUserTitle;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get userName;

  /// No description provided for @userEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get userEmail;

  /// No description provided for @userEmailHelp.
  ///
  /// In en, this message translates to:
  /// **'They log in with it.'**
  String get userEmailHelp;

  /// No description provided for @userRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get userRole;

  /// No description provided for @userRoleHelp.
  ///
  /// In en, this message translates to:
  /// **'Editors can add and edit, but can\'t delete or manage users.'**
  String get userRoleHelp;

  /// No description provided for @emailTaken.
  ///
  /// In en, this message translates to:
  /// **'This email already has an account.'**
  String get emailTaken;

  /// No description provided for @userCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'User added'**
  String get userCreatedTitle;

  /// No description provided for @userCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Give these details to {name}. They will choose their own password when they first log in.'**
  String userCreatedMessage(String name);

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Login email'**
  String get loginEmail;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Give them a new temporary password'**
  String get resetPasswordHint;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset {name}\'s password?'**
  String resetPasswordTitle(String name);

  /// No description provided for @resetPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'They\'ll get a new temporary password and be logged out everywhere. Their current password stops working.'**
  String get resetPasswordMessage;

  /// No description provided for @newPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordTitle;

  /// No description provided for @newPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Give this to {name}. They will choose their own password when they next log in.'**
  String newPasswordMessage(String name);

  /// No description provided for @disableUser.
  ///
  /// In en, this message translates to:
  /// **'Disable user'**
  String get disableUser;

  /// No description provided for @disableUserHint.
  ///
  /// In en, this message translates to:
  /// **'Log them out and stop them logging in'**
  String get disableUserHint;

  /// No description provided for @enableUser.
  ///
  /// In en, this message translates to:
  /// **'Enable user'**
  String get enableUser;

  /// No description provided for @disableUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Disable {name}?'**
  String disableUserTitle(String name);

  /// No description provided for @disableUserMessage.
  ///
  /// In en, this message translates to:
  /// **'They\'re logged out everywhere and can\'t log in until you enable them again.'**
  String get disableUserMessage;

  /// No description provided for @userDisabledDone.
  ///
  /// In en, this message translates to:
  /// **'User disabled'**
  String get userDisabledDone;

  /// No description provided for @userEnabledDone.
  ///
  /// In en, this message translates to:
  /// **'User enabled'**
  String get userEnabledDone;
}

class _AdminLocalizationsDelegate
    extends LocalizationsDelegate<AdminLocalizations> {
  const _AdminLocalizationsDelegate();

  @override
  Future<AdminLocalizations> load(Locale locale) {
    return SynchronousFuture<AdminLocalizations>(
      lookupAdminLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AdminLocalizationsDelegate old) => false;
}

AdminLocalizations lookupAdminLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AdminLocalizationsAr();
    case 'en':
      return AdminLocalizationsEn();
  }

  throw FlutterError(
    'AdminLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
