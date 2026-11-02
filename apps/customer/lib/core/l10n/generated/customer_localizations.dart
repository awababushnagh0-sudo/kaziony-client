import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'customer_localizations_ar.dart';
import 'customer_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of CustomerLocalizations
/// returned by `CustomerLocalizations.of(context)`.
///
/// Applications need to include `CustomerLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/customer_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: CustomerLocalizations.localizationsDelegates,
///   supportedLocales: CustomerLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the CustomerLocalizations.supportedLocales
/// property.
abstract class CustomerLocalizations {
  CustomerLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static CustomerLocalizations of(BuildContext context) {
    return Localizations.of<CustomerLocalizations>(
      context,
      CustomerLocalizations,
    )!;
  }

  static const LocalizationsDelegate<CustomerLocalizations> delegate =
      _CustomerLocalizationsDelegate();

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
  /// **'Kaziony'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @bookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My bookings'**
  String get bookingsTitle;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @helloTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Kaziony'**
  String get helloTitle;

  /// No description provided for @helloText.
  ///
  /// In en, this message translates to:
  /// **'Offers from stores near you will be here soon.'**
  String get helloText;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTitle;

  /// No description provided for @signInMessage.
  ///
  /// In en, this message translates to:
  /// **'To book offers and follow your favorite stores. You can browse without an account.'**
  String get signInMessage;

  /// No description provided for @guestTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome, dear guest!'**
  String get guestTitle;

  /// No description provided for @guestMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to book offers before they run out and follow your favorite stores.'**
  String get guestMessage;

  /// No description provided for @signInAction.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInAction;

  /// No description provided for @termsAgreement.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to the'**
  String get termsAgreement;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and Privacy Policy'**
  String get termsTitle;

  /// No description provided for @termsSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get termsSoonTitle;

  /// No description provided for @termsSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'The terms and privacy policy will be here before the app opens to everyone.'**
  String get termsSoonMessage;

  /// No description provided for @bookingsSignedOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your bookings'**
  String get bookingsSignedOutTitle;

  /// No description provided for @bookingsSignedOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Your bookings and pickup codes show up here.'**
  String get bookingsSignedOutMessage;

  /// No description provided for @appSection.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get appSection;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Because good food shouldn\'t go to waste'**
  String get tagline;

  /// No description provided for @helloMessage.
  ///
  /// In en, this message translates to:
  /// **'Real offers from stores near you, in limited quantities. Book before they run out.'**
  String get helloMessage;

  /// No description provided for @whyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why Kaziony?'**
  String get whyTitle;

  /// No description provided for @whyLessWaste.
  ///
  /// In en, this message translates to:
  /// **'Less food thrown away, more of it reaching people.'**
  String get whyLessWaste;

  /// No description provided for @whySaveMoney.
  ///
  /// In en, this message translates to:
  /// **'The same quality for less.'**
  String get whySaveMoney;

  /// No description provided for @whyLocalStores.
  ///
  /// In en, this message translates to:
  /// **'You support the stores in your neighborhood.'**
  String get whyLocalStores;

  /// No description provided for @howTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howTitle;

  /// No description provided for @howBook.
  ///
  /// In en, this message translates to:
  /// **'Book the offer in the app.'**
  String get howBook;

  /// No description provided for @howPickUp.
  ///
  /// In en, this message translates to:
  /// **'Pick it up from the store on time.'**
  String get howPickUp;

  /// No description provided for @howPay.
  ///
  /// In en, this message translates to:
  /// **'Pay cash when you pick it up.'**
  String get howPay;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Where are you?'**
  String get locationTitle;

  /// No description provided for @locationMessage.
  ///
  /// In en, this message translates to:
  /// **'We only show offers from stores near you. Stores never see your location.'**
  String get locationMessage;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @locationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location wasn\'t allowed. You can set your place on the map instead.'**
  String get locationDenied;

  /// No description provided for @locationDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location is off for Kaziony. Allow it in Settings, or set your place on the map.'**
  String get locationDeniedForever;

  /// No description provided for @locationOff.
  ///
  /// In en, this message translates to:
  /// **'Location is off on your phone. Turn it on, or set your place on the map.'**
  String get locationOff;

  /// No description provided for @locationFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find your location. Try again, or set your place on the map.'**
  String get locationFailed;

  /// No description provided for @myLocation.
  ///
  /// In en, this message translates to:
  /// **'My current location'**
  String get myLocation;

  /// No description provided for @locationRow.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationRow;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuest;

  /// No description provided for @appleSignInSoon.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple is coming soon.'**
  String get appleSignInSoon;

  /// No description provided for @setOnMap.
  ///
  /// In en, this message translates to:
  /// **'Set it on the map'**
  String get setOnMap;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your place'**
  String get mapTitle;

  /// No description provided for @mapHint.
  ///
  /// In en, this message translates to:
  /// **'Move the map until the pin is on your place.'**
  String get mapHint;

  /// No description provided for @confirmPlace.
  ///
  /// In en, this message translates to:
  /// **'Confirm place'**
  String get confirmPlace;

  /// No description provided for @myLocationButton.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get myLocationButton;

  /// No description provided for @pinnedLocation.
  ///
  /// In en, this message translates to:
  /// **'A place on the map'**
  String get pinnedLocation;

  /// No description provided for @listSeparator.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get listSeparator;

  /// No description provided for @outsideServiceArea.
  ///
  /// In en, this message translates to:
  /// **'Kaziony is only in {areas} for now.'**
  String outsideServiceArea(String areas);
}

class _CustomerLocalizationsDelegate
    extends LocalizationsDelegate<CustomerLocalizations> {
  const _CustomerLocalizationsDelegate();

  @override
  Future<CustomerLocalizations> load(Locale locale) {
    return SynchronousFuture<CustomerLocalizations>(
      lookupCustomerLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_CustomerLocalizationsDelegate old) => false;
}

CustomerLocalizations lookupCustomerLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return CustomerLocalizationsAr();
    case 'en':
      return CustomerLocalizationsEn();
  }

  throw FlutterError(
    'CustomerLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
