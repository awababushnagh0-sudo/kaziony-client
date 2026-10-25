import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'partner_localizations_ar.dart';
import 'partner_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of PartnerLocalizations
/// returned by `PartnerLocalizations.of(context)`.
///
/// Applications need to include `PartnerLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/partner_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: PartnerLocalizations.localizationsDelegates,
///   supportedLocales: PartnerLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the PartnerLocalizations.supportedLocales
/// property.
abstract class PartnerLocalizations {
  PartnerLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static PartnerLocalizations of(BuildContext context) {
    return Localizations.of<PartnerLocalizations>(
      context,
      PartnerLocalizations,
    )!;
  }

  static const LocalizationsDelegate<PartnerLocalizations> delegate =
      _PartnerLocalizationsDelegate();

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
  /// **'Offers for Stores'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Store login'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the phone number and password you got from our team.'**
  String get loginSubtitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @wrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong phone number or password.'**
  String get wrongCredentials;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account is disabled. Contact us.'**
  String get accountDisabled;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session ended. Please log in again.'**
  String get sessionExpired;

  /// No description provided for @notStoreAccount.
  ///
  /// In en, this message translates to:
  /// **'This app is for store accounts only.'**
  String get notStoreAccount;

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

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @chooseStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a store'**
  String get chooseStoreTitle;

  /// No description provided for @chooseStoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You work at more than one store. You can switch later from your profile.'**
  String get chooseStoreSubtitle;

  /// No description provided for @ownerRole.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerRole;

  /// No description provided for @staffRole.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffRole;

  /// No description provided for @switchStore.
  ///
  /// In en, this message translates to:
  /// **'Switch store'**
  String get switchStore;

  /// No description provided for @noStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'No store yet'**
  String get noStoreTitle;

  /// No description provided for @noStoreMessage.
  ///
  /// In en, this message translates to:
  /// **'This account isn\'t linked to a store. Contact our team to set it up.'**
  String get noStoreMessage;

  /// No description provided for @storeSection.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get storeSection;

  /// No description provided for @storeInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Store info'**
  String get storeInfoTitle;

  /// No description provided for @storeInfoHint.
  ///
  /// In en, this message translates to:
  /// **'Customers see this on your store\'s page.'**
  String get storeInfoHint;

  /// No description provided for @branchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branchesTitle;

  /// No description provided for @teamTitle.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamTitle;

  /// No description provided for @teamHint.
  ///
  /// In en, this message translates to:
  /// **'To add or remove someone, contact our team.'**
  String get teamHint;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @changePasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordAction;

  /// No description provided for @appSection.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get appSection;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @facebookLabel.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebookLabel;

  /// No description provided for @instagramLabel.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagramLabel;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get saved;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @allBranches.
  ///
  /// In en, this message translates to:
  /// **'All branches'**
  String get allBranches;

  /// No description provided for @cityTripoli.
  ///
  /// In en, this message translates to:
  /// **'Tripoli'**
  String get cityTripoli;

  /// No description provided for @oldPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get oldPasswordLabel;

  /// No description provided for @wrongOldPassword.
  ///
  /// In en, this message translates to:
  /// **'The current password is wrong.'**
  String get wrongOldPassword;

  /// No description provided for @productsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTitle;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProduct;

  /// No description provided for @newProductTitle.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get newProductTitle;

  /// No description provided for @editProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProductTitle;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchProducts;

  /// No description provided for @currentProducts.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentProducts;

  /// No description provided for @archivedProducts.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archivedProducts;

  /// No description provided for @noProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProductsTitle;

  /// No description provided for @noProductsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add what you sell, then post offers from it in seconds.'**
  String get noProductsMessage;

  /// No description provided for @noProductsMatch.
  ///
  /// In en, this message translates to:
  /// **'No products match your search.'**
  String get noProductsMatch;

  /// No description provided for @noArchivedProducts.
  ///
  /// In en, this message translates to:
  /// **'No archived products.'**
  String get noArchivedProducts;

  /// No description provided for @productTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get productTitleLabel;

  /// No description provided for @regularPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Regular price'**
  String get regularPriceLabel;

  /// No description provided for @regularPriceHelper.
  ///
  /// In en, this message translates to:
  /// **'The usual price, before any offer.'**
  String get regularPriceHelper;

  /// No description provided for @archiveProduct.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveProduct;

  /// No description provided for @restoreProduct.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreProduct;

  /// No description provided for @productArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived.'**
  String get productArchived;

  /// No description provided for @productRestored.
  ///
  /// In en, this message translates to:
  /// **'Restored.'**
  String get productRestored;

  /// No description provided for @productAddedAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Saved. Now add its photo.'**
  String get productAddedAddPhoto;
}

class _PartnerLocalizationsDelegate
    extends LocalizationsDelegate<PartnerLocalizations> {
  const _PartnerLocalizationsDelegate();

  @override
  Future<PartnerLocalizations> load(Locale locale) {
    return SynchronousFuture<PartnerLocalizations>(
      lookupPartnerLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_PartnerLocalizationsDelegate old) => false;
}

PartnerLocalizations lookupPartnerLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return PartnerLocalizationsAr();
    case 'en':
      return PartnerLocalizationsEn();
  }

  throw FlutterError(
    'PartnerLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
