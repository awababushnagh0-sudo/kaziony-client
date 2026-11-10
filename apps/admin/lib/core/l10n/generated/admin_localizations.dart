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

  /// No description provided for @storePickupInstructions.
  ///
  /// In en, this message translates to:
  /// **'Pickup instructions'**
  String get storePickupInstructions;

  /// No description provided for @storePickupInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Show your code at the cashier by the door; bring a bag.'**
  String get storePickupInstructionsHint;

  /// No description provided for @storeRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get storeRating;

  /// No description provided for @ratingSummary.
  ///
  /// In en, this message translates to:
  /// **'★ {average} · {count, plural, =1{1 rating} other{{count} ratings}}'**
  String ratingSummary(double average, int count);

  /// No description provided for @noRatingsYet.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get noRatingsYet;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers Admin'**
  String get appTitle;

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

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsAppearanceHint.
  ///
  /// In en, this message translates to:
  /// **'How the dashboard looks on this device.'**
  String get settingsAppearanceHint;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeHint.
  ///
  /// In en, this message translates to:
  /// **'Automatic follows your device\'s light or dark setting.'**
  String get settingsThemeHint;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'The dashboard\'s language on this device. Arabic reads right to left.'**
  String get settingsLanguageHint;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @navPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform settings'**
  String get navPlatform;

  /// No description provided for @platformSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Platform settings'**
  String get platformSettingsTitle;

  /// No description provided for @platformBrowseSection.
  ///
  /// In en, this message translates to:
  /// **'Browsing offers'**
  String get platformBrowseSection;

  /// No description provided for @browseRadiusLabel.
  ///
  /// In en, this message translates to:
  /// **'Offer radius (km)'**
  String get browseRadiusLabel;

  /// No description provided for @browseRadiusHint.
  ///
  /// In en, this message translates to:
  /// **'Customers see offers from branches within this distance of them, {min} to {max} km. Takes effect right away.'**
  String browseRadiusHint(int min, int max);

  /// No description provided for @browseRadiusEditorHint.
  ///
  /// In en, this message translates to:
  /// **'Customers see offers from branches within this distance of them. Only admins change it.'**
  String get browseRadiusEditorHint;

  /// No description provided for @platformAreasSection.
  ///
  /// In en, this message translates to:
  /// **'Service areas'**
  String get platformAreasSection;

  /// No description provided for @serviceAreasHelp.
  ///
  /// In en, this message translates to:
  /// **'Customers can only browse offers from inside these circles; the app draws them on its map.'**
  String get serviceAreasHelp;

  /// No description provided for @addServiceArea.
  ///
  /// In en, this message translates to:
  /// **'Add area'**
  String get addServiceArea;

  /// No description provided for @addServiceAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'New service area'**
  String get addServiceAreaTitle;

  /// No description provided for @editServiceAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit service area'**
  String get editServiceAreaTitle;

  /// No description provided for @serviceAreaNameAr.
  ///
  /// In en, this message translates to:
  /// **'Name in Arabic'**
  String get serviceAreaNameAr;

  /// No description provided for @serviceAreaNameEn.
  ///
  /// In en, this message translates to:
  /// **'Name in English'**
  String get serviceAreaNameEn;

  /// No description provided for @serviceAreaCenter.
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get serviceAreaCenter;

  /// No description provided for @serviceAreaCenterHelp.
  ///
  /// In en, this message translates to:
  /// **'From Google Maps: click the city\'s center and copy its coordinates.'**
  String get serviceAreaCenterHelp;

  /// No description provided for @invalidCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Enter latitude then longitude, like 32.85, 13.18'**
  String get invalidCoordinates;

  /// No description provided for @serviceAreaRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius (km)'**
  String get serviceAreaRadius;

  /// No description provided for @serviceAreaRadiusHint.
  ///
  /// In en, this message translates to:
  /// **'{min} to {max} km around the center.'**
  String serviceAreaRadiusHint(int min, int max);

  /// No description provided for @serviceAreaOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get serviceAreaOn;

  /// No description provided for @serviceAreaOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get serviceAreaOff;

  /// No description provided for @serviceAreasTotal.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 area} other{{count} areas}}'**
  String serviceAreasTotal(int count);

  /// No description provided for @deleteServiceArea.
  ///
  /// In en, this message translates to:
  /// **'Delete area'**
  String get deleteServiceArea;

  /// No description provided for @deleteServiceAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {area}?'**
  String deleteServiceAreaTitle(String area);

  /// No description provided for @deleteServiceAreaMessage.
  ///
  /// In en, this message translates to:
  /// **'Customers there won\'t be able to browse offers. To pause it, turn it off instead.'**
  String get deleteServiceAreaMessage;

  /// No description provided for @navSearches.
  ///
  /// In en, this message translates to:
  /// **'Searches'**
  String get navSearches;

  /// No description provided for @searchesTitle.
  ///
  /// In en, this message translates to:
  /// **'What customers search for'**
  String get searchesTitle;

  /// No description provided for @searchesSearch.
  ///
  /// In en, this message translates to:
  /// **'Search the searches'**
  String get searchesSearch;

  /// No description provided for @searchesTotal.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 search} other{{count} searches}}'**
  String searchesTotal(int count);

  /// No description provided for @searchesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No searches yet'**
  String get searchesEmpty;

  /// No description provided for @searchesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'What customers search for in the app shows here, the most searched first.'**
  String get searchesEmptyMessage;

  /// No description provided for @filterNothingFound.
  ///
  /// In en, this message translates to:
  /// **'Found nothing'**
  String get filterNothingFound;

  /// No description provided for @filterFound.
  ///
  /// In en, this message translates to:
  /// **'Found offers'**
  String get filterFound;

  /// No description provided for @columnSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get columnSearch;

  /// No description provided for @columnSearchCount.
  ///
  /// In en, this message translates to:
  /// **'Times searched'**
  String get columnSearchCount;

  /// No description provided for @columnFound.
  ///
  /// In en, this message translates to:
  /// **'Last found'**
  String get columnFound;

  /// No description provided for @columnLastSearched.
  ///
  /// In en, this message translates to:
  /// **'Last searched'**
  String get columnLastSearched;

  /// No description provided for @foundNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing'**
  String get foundNothing;

  /// No description provided for @foundOffers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 offer} other{{count} offers}}'**
  String foundOffers(int count);

  /// No description provided for @navSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get navSystem;

  /// No description provided for @systemTitle.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTitle;

  /// No description provided for @systemTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get systemTabOverview;

  /// No description provided for @systemTabTraffic.
  ///
  /// In en, this message translates to:
  /// **'Traffic'**
  String get systemTabTraffic;

  /// No description provided for @systemTabErrors.
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get systemTabErrors;

  /// No description provided for @systemTabJobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get systemTabJobs;

  /// No description provided for @systemTabDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get systemTabDatabase;

  /// No description provided for @systemRedis.
  ///
  /// In en, this message translates to:
  /// **'Redis (shared cache)'**
  String get systemRedis;

  /// No description provided for @systemInstances.
  ///
  /// In en, this message translates to:
  /// **'Instances'**
  String get systemInstances;

  /// No description provided for @systemCheckedAt.
  ///
  /// In en, this message translates to:
  /// **'Checked'**
  String get systemCheckedAt;

  /// No description provided for @systemCheckedAtValue.
  ///
  /// In en, this message translates to:
  /// **'{time} · every 15 seconds'**
  String systemCheckedAtValue(String time);

  /// No description provided for @systemAllGood.
  ///
  /// In en, this message translates to:
  /// **'Everything is running'**
  String get systemAllGood;

  /// No description provided for @systemNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Something needs a look'**
  String get systemNeedsAttention;

  /// No description provided for @healthUp.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get healthUp;

  /// No description provided for @healthDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get healthDown;

  /// No description provided for @healthOff.
  ///
  /// In en, this message translates to:
  /// **'Not set up'**
  String get healthOff;

  /// No description provided for @unitMs.
  ///
  /// In en, this message translates to:
  /// **'{value} ms'**
  String unitMs(String value);

  /// No description provided for @unitKb.
  ///
  /// In en, this message translates to:
  /// **'{value} KB'**
  String unitKb(String value);

  /// No description provided for @unitMb.
  ///
  /// In en, this message translates to:
  /// **'{value} MB'**
  String unitMb(String value);

  /// No description provided for @unitGb.
  ///
  /// In en, this message translates to:
  /// **'{value} GB'**
  String unitGb(String value);

  /// No description provided for @unitPercent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String unitPercent(String value);

  /// No description provided for @uptimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String uptimeMinutes(int minutes);

  /// No description provided for @uptimeHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String uptimeHours(int hours, int minutes);

  /// No description provided for @uptimeDays.
  ///
  /// In en, this message translates to:
  /// **'{days} d {hours} h'**
  String uptimeDays(int days, int hours);

  /// No description provided for @figureRequestsPerMinute.
  ///
  /// In en, this message translates to:
  /// **'Requests a minute'**
  String get figureRequestsPerMinute;

  /// No description provided for @figureServerErrors.
  ///
  /// In en, this message translates to:
  /// **'Server errors'**
  String get figureServerErrors;

  /// No description provided for @figureServerErrorsHint.
  ///
  /// In en, this message translates to:
  /// **'{count} in 5 minutes'**
  String figureServerErrorsHint(int count);

  /// No description provided for @figureLatency.
  ///
  /// In en, this message translates to:
  /// **'Response time (p95)'**
  String get figureLatency;

  /// No description provided for @figureLast5Minutes.
  ///
  /// In en, this message translates to:
  /// **'Last 5 minutes'**
  String get figureLast5Minutes;

  /// No description provided for @figureErrorKinds.
  ///
  /// In en, this message translates to:
  /// **'Kinds of errors'**
  String get figureErrorKinds;

  /// No description provided for @figureLastDay.
  ///
  /// In en, this message translates to:
  /// **'Last 24 hours'**
  String get figureLastDay;

  /// No description provided for @figureFailingJobs.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No job failing} =1{1 job failing} other{{count} jobs failing}}'**
  String figureFailingJobs(int count);

  /// No description provided for @instanceThisOne.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get instanceThisOne;

  /// No description provided for @instanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version {version} · up {uptime}'**
  String instanceSubtitle(String version, String uptime);

  /// No description provided for @instanceMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get instanceMemory;

  /// No description provided for @instanceMemoryValue.
  ///
  /// In en, this message translates to:
  /// **'{total} ({heap} in use by JavaScript)'**
  String instanceMemoryValue(String total, String heap);

  /// No description provided for @instanceCpu.
  ///
  /// In en, this message translates to:
  /// **'Processor'**
  String get instanceCpu;

  /// No description provided for @instanceEventLoop.
  ///
  /// In en, this message translates to:
  /// **'Event loop delay'**
  String get instanceEventLoop;

  /// No description provided for @instanceConnections.
  ///
  /// In en, this message translates to:
  /// **'Database connections'**
  String get instanceConnections;

  /// No description provided for @instanceConnectionsValue.
  ///
  /// In en, this message translates to:
  /// **'{open} open · {idle} idle · {waiting} waiting · up to {max}'**
  String instanceConnectionsValue(int open, int idle, int waiting, int max);

  /// No description provided for @instanceRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests a minute'**
  String get instanceRequests;

  /// No description provided for @instanceStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get instanceStarted;

  /// No description provided for @instanceReported.
  ///
  /// In en, this message translates to:
  /// **'Last report'**
  String get instanceReported;

  /// No description provided for @trafficWindow.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String trafficWindow(int minutes);

  /// No description provided for @trafficSummary.
  ///
  /// In en, this message translates to:
  /// **'{requests} requests and {errors} server errors in the last {minutes} minutes'**
  String trafficSummary(int requests, int errors, int minutes);

  /// No description provided for @trafficMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String trafficMinutesAgo(int minutes);

  /// No description provided for @trafficNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get trafficNow;

  /// No description provided for @trafficBar.
  ///
  /// In en, this message translates to:
  /// **'{time} · {requests} requests · {errors} errors'**
  String trafficBar(String time, int requests, int errors);

  /// No description provided for @trafficRoutes.
  ///
  /// In en, this message translates to:
  /// **'Routes, busiest first'**
  String get trafficRoutes;

  /// No description provided for @trafficRouteLatency.
  ///
  /// In en, this message translates to:
  /// **'p50 {p50} · p95 {p95} · p99 {p99}'**
  String trafficRouteLatency(String p50, String p95, String p99);

  /// No description provided for @trafficRouteErrors.
  ///
  /// In en, this message translates to:
  /// **'{latency} · {errors} server errors · {refused} refused'**
  String trafficRouteErrors(String latency, int errors, int refused);

  /// No description provided for @trafficEmpty.
  ///
  /// In en, this message translates to:
  /// **'No requests yet'**
  String get trafficEmpty;

  /// No description provided for @trafficEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Requests show here as the apps use the API.'**
  String get trafficEmptyMessage;

  /// No description provided for @errorsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No server errors'**
  String get errorsEmpty;

  /// No description provided for @errorsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Errors of the last 24 hours show here, the same error on the same route as one.'**
  String get errorsEmptyMessage;

  /// No description provided for @errorTimes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{once} other{{count} times}}'**
  String errorTimes(int count);

  /// No description provided for @errorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{route} · {times} · last {when}'**
  String errorSubtitle(String route, String times, String when);

  /// No description provided for @errorRequestId.
  ///
  /// In en, this message translates to:
  /// **'Last request id (finds it in the logs)'**
  String get errorRequestId;

  /// No description provided for @errorFirstSeen.
  ///
  /// In en, this message translates to:
  /// **'First seen'**
  String get errorFirstSeen;

  /// No description provided for @errorLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get errorLastSeen;

  /// No description provided for @errorStack.
  ///
  /// In en, this message translates to:
  /// **'Where it happened'**
  String get errorStack;

  /// No description provided for @jobRunNow.
  ///
  /// In en, this message translates to:
  /// **'Run now'**
  String get jobRunNow;

  /// No description provided for @jobRan.
  ///
  /// In en, this message translates to:
  /// **'Done in {duration}'**
  String jobRan(String duration);

  /// No description provided for @jobRanFailed.
  ///
  /// In en, this message translates to:
  /// **'The job failed: its last error says why.'**
  String get jobRanFailed;

  /// No description provided for @jobAlreadyRunning.
  ///
  /// In en, this message translates to:
  /// **'This job is running right now.'**
  String get jobAlreadyRunning;

  /// No description provided for @jobSucceeded.
  ///
  /// In en, this message translates to:
  /// **'Succeeded'**
  String get jobSucceeded;

  /// No description provided for @jobFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get jobFailed;

  /// No description provided for @jobRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get jobRunning;

  /// No description provided for @jobNeverRun.
  ///
  /// In en, this message translates to:
  /// **'Not run yet'**
  String get jobNeverRun;

  /// No description provided for @jobSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule (cron)'**
  String get jobSchedule;

  /// No description provided for @jobByHand.
  ///
  /// In en, this message translates to:
  /// **'Only by hand'**
  String get jobByHand;

  /// No description provided for @jobNextRun.
  ///
  /// In en, this message translates to:
  /// **'Next run'**
  String get jobNextRun;

  /// No description provided for @jobLastRun.
  ///
  /// In en, this message translates to:
  /// **'Last run'**
  String get jobLastRun;

  /// No description provided for @jobLastRunValue.
  ///
  /// In en, this message translates to:
  /// **'{when} · {duration}'**
  String jobLastRunValue(String when, String duration);

  /// No description provided for @jobLastResult.
  ///
  /// In en, this message translates to:
  /// **'What it did'**
  String get jobLastResult;

  /// No description provided for @jobRuns.
  ///
  /// In en, this message translates to:
  /// **'Runs'**
  String get jobRuns;

  /// No description provided for @jobRunsValue.
  ///
  /// In en, this message translates to:
  /// **'{runs} ({failures} failed)'**
  String jobRunsValue(int runs, int failures);

  /// No description provided for @jobLastError.
  ///
  /// In en, this message translates to:
  /// **'Last error'**
  String get jobLastError;

  /// No description provided for @jobsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No jobs'**
  String get jobsEmpty;

  /// No description provided for @dbSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get dbSize;

  /// No description provided for @dbConnections.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get dbConnections;

  /// No description provided for @dbConnectionsHint.
  ///
  /// In en, this message translates to:
  /// **'{active} active · up to {max}'**
  String dbConnectionsHint(int active, int max);

  /// No description provided for @dbCacheHit.
  ///
  /// In en, this message translates to:
  /// **'Read from memory'**
  String get dbCacheHit;

  /// No description provided for @dbCacheHitHint.
  ///
  /// In en, this message translates to:
  /// **'Below 99%, it needs more memory'**
  String get dbCacheHitHint;

  /// No description provided for @dbWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get dbWaiting;

  /// No description provided for @dbWaitingHint.
  ///
  /// In en, this message translates to:
  /// **'{locks} on locks · {idle} idle in a transaction'**
  String dbWaitingHint(int locks, int idle);

  /// No description provided for @dbVersion.
  ///
  /// In en, this message translates to:
  /// **'Postgres {version}'**
  String dbVersion(String version);

  /// No description provided for @dbStatementsOff.
  ///
  /// In en, this message translates to:
  /// **'Query timings are off'**
  String get dbStatementsOff;

  /// No description provided for @dbStatementsOffMessage.
  ///
  /// In en, this message translates to:
  /// **'Load pg_stat_statements in Postgres to see the queries taking the most time.'**
  String get dbStatementsOffMessage;

  /// No description provided for @dbRunning.
  ///
  /// In en, this message translates to:
  /// **'Running for over a second'**
  String get dbRunning;

  /// No description provided for @dbRunningWaiting.
  ///
  /// In en, this message translates to:
  /// **'{duration} · waiting for {what}'**
  String dbRunningWaiting(String duration, String what);

  /// No description provided for @dbSlowest.
  ///
  /// In en, this message translates to:
  /// **'Taking the most time'**
  String get dbSlowest;

  /// No description provided for @dbQueryStats.
  ///
  /// In en, this message translates to:
  /// **'{calls} runs · {mean} each · {total} in all'**
  String dbQueryStats(int calls, String mean, String total);

  /// No description provided for @dbTables.
  ///
  /// In en, this message translates to:
  /// **'Tables, biggest first'**
  String get dbTables;

  /// No description provided for @dbTableRows.
  ///
  /// In en, this message translates to:
  /// **'{rows} rows · {dead} waiting for cleanup'**
  String dbTableRows(int rows, int dead);

  /// No description provided for @systemStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get systemStatus;

  /// No description provided for @jobExpireClaims.
  ///
  /// In en, this message translates to:
  /// **'Expires missed pickups: the pieces go back on sale, the customer gets a strike, every third one blocks booking for 7 days. Ends offers whose time is up.'**
  String get jobExpireClaims;

  /// No description provided for @jobExpireClaimsBacklog.
  ///
  /// In en, this message translates to:
  /// **'Bookings past their time'**
  String get jobExpireClaimsBacklog;

  /// No description provided for @jobCleanTokens.
  ///
  /// In en, this message translates to:
  /// **'Deletes sign-in tokens that ran out, or were used or revoked over 7 days ago.'**
  String get jobCleanTokens;

  /// No description provided for @jobCleanTokensBacklog.
  ///
  /// In en, this message translates to:
  /// **'Tokens to delete'**
  String get jobCleanTokensBacklog;

  /// No description provided for @jobCleanSearchTerms.
  ///
  /// In en, this message translates to:
  /// **'Deletes searches made fewer than 3 times, and not in the last 90 days.'**
  String get jobCleanSearchTerms;

  /// No description provided for @jobCleanSearchTermsBacklog.
  ///
  /// In en, this message translates to:
  /// **'Searches to delete'**
  String get jobCleanSearchTermsBacklog;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Who changed what'**
  String get activityTitle;

  /// No description provided for @activitySearch.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get activitySearch;

  /// No description provided for @activityTotal.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 change} other{{count} changes}}'**
  String activityTotal(int count);

  /// No description provided for @activityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No changes yet'**
  String get activityEmpty;

  /// No description provided for @activityEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Every change made in the dashboard shows here: who made it, and when.'**
  String get activityEmptyMessage;

  /// No description provided for @activityAreaServiceAreas.
  ///
  /// In en, this message translates to:
  /// **'Service areas'**
  String get activityAreaServiceAreas;

  /// No description provided for @activityAreaSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get activityAreaSettings;

  /// No description provided for @activityAreaJobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get activityAreaJobs;

  /// No description provided for @columnWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get columnWhen;

  /// No description provided for @columnWho.
  ///
  /// In en, this message translates to:
  /// **'Who'**
  String get columnWho;

  /// No description provided for @columnWhat.
  ///
  /// In en, this message translates to:
  /// **'What'**
  String get columnWhat;

  /// No description provided for @columnItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get columnItem;

  /// No description provided for @columnFields.
  ///
  /// In en, this message translates to:
  /// **'Fields'**
  String get columnFields;

  /// No description provided for @activityRemovedAccount.
  ///
  /// In en, this message translates to:
  /// **'A removed account'**
  String get activityRemovedAccount;

  /// No description provided for @activityRequestId.
  ///
  /// In en, this message translates to:
  /// **'Request id (finds it in the logs)'**
  String get activityRequestId;

  /// No description provided for @activitySent.
  ///
  /// In en, this message translates to:
  /// **'What was sent'**
  String get activitySent;

  /// No description provided for @activityNothingSent.
  ///
  /// In en, this message translates to:
  /// **'Nothing was sent'**
  String get activityNothingSent;

  /// No description provided for @activityStoreCreate.
  ///
  /// In en, this message translates to:
  /// **'Added a store'**
  String get activityStoreCreate;

  /// No description provided for @activityStoreUpdate.
  ///
  /// In en, this message translates to:
  /// **'Edited a store'**
  String get activityStoreUpdate;

  /// No description provided for @activityStoreDelete.
  ///
  /// In en, this message translates to:
  /// **'Deleted a store'**
  String get activityStoreDelete;

  /// No description provided for @activityStoreAddBranch.
  ///
  /// In en, this message translates to:
  /// **'Added a branch'**
  String get activityStoreAddBranch;

  /// No description provided for @activityStoreUpdateBranch.
  ///
  /// In en, this message translates to:
  /// **'Edited a branch'**
  String get activityStoreUpdateBranch;

  /// No description provided for @activityStoreAddMember.
  ///
  /// In en, this message translates to:
  /// **'Added someone to a store'**
  String get activityStoreAddMember;

  /// No description provided for @activityStoreRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Removed someone from a store'**
  String get activityStoreRemoveMember;

  /// No description provided for @activityUserCreate.
  ///
  /// In en, this message translates to:
  /// **'Added a team member'**
  String get activityUserCreate;

  /// No description provided for @activityUserUpdate.
  ///
  /// In en, this message translates to:
  /// **'Edited an account'**
  String get activityUserUpdate;

  /// No description provided for @activityUserDisable.
  ///
  /// In en, this message translates to:
  /// **'Disabled an account'**
  String get activityUserDisable;

  /// No description provided for @activityUserEnable.
  ///
  /// In en, this message translates to:
  /// **'Enabled an account'**
  String get activityUserEnable;

  /// No description provided for @activityUserResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset a password'**
  String get activityUserResetPassword;

  /// No description provided for @activityCategoryCreate.
  ///
  /// In en, this message translates to:
  /// **'Added a category'**
  String get activityCategoryCreate;

  /// No description provided for @activityCategoryUpdate.
  ///
  /// In en, this message translates to:
  /// **'Edited a category'**
  String get activityCategoryUpdate;

  /// No description provided for @activityServiceAreaCreate.
  ///
  /// In en, this message translates to:
  /// **'Added a service area'**
  String get activityServiceAreaCreate;

  /// No description provided for @activityServiceAreaUpdate.
  ///
  /// In en, this message translates to:
  /// **'Edited a service area'**
  String get activityServiceAreaUpdate;

  /// No description provided for @activityServiceAreaDelete.
  ///
  /// In en, this message translates to:
  /// **'Deleted a service area'**
  String get activityServiceAreaDelete;

  /// No description provided for @activitySettingsUpdate.
  ///
  /// In en, this message translates to:
  /// **'Changed the platform settings'**
  String get activitySettingsUpdate;

  /// No description provided for @activityOfferRemove.
  ///
  /// In en, this message translates to:
  /// **'Took an offer down'**
  String get activityOfferRemove;

  /// No description provided for @activityJobRun.
  ///
  /// In en, this message translates to:
  /// **'Ran a job by hand'**
  String get activityJobRun;
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
