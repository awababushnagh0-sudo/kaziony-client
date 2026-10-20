import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'business_localizations_ar.dart';
import 'business_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of BusinessLocalizations
/// returned by `BusinessLocalizations.of(context)`.
///
/// Applications need to include `BusinessLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/business_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: BusinessLocalizations.localizationsDelegates,
///   supportedLocales: BusinessLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the BusinessLocalizations.supportedLocales
/// property.
abstract class BusinessLocalizations {
  BusinessLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static BusinessLocalizations of(BuildContext context) {
    return Localizations.of<BusinessLocalizations>(
      context,
      BusinessLocalizations,
    )!;
  }

  static const LocalizationsDelegate<BusinessLocalizations> delegate =
      _BusinessLocalizationsDelegate();

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

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get switchLanguage;

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

  /// No description provided for @branchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branchesTitle;

  /// No description provided for @storeActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get storeActive;

  /// No description provided for @storeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled. Contact us to re-enable it.'**
  String get storeDisabled;

  /// No description provided for @branchClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get branchClosed;

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

  /// No description provided for @noStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'No store is linked to this account'**
  String get noStoreTitle;

  /// No description provided for @noStoreMessage.
  ///
  /// In en, this message translates to:
  /// **'Contact our team to set up your store.'**
  String get noStoreMessage;

  /// No description provided for @comingNext.
  ///
  /// In en, this message translates to:
  /// **'Products and offers are coming next.'**
  String get comingNext;
}

class _BusinessLocalizationsDelegate
    extends LocalizationsDelegate<BusinessLocalizations> {
  const _BusinessLocalizationsDelegate();

  @override
  Future<BusinessLocalizations> load(Locale locale) {
    return SynchronousFuture<BusinessLocalizations>(
      lookupBusinessLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_BusinessLocalizationsDelegate old) => false;
}

BusinessLocalizations lookupBusinessLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return BusinessLocalizationsAr();
    case 'en':
      return BusinessLocalizationsEn();
  }

  throw FlutterError(
    'BusinessLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
