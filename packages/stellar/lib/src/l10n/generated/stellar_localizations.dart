import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'stellar_localizations_ar.dart';
import 'stellar_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of StellarLocalizations
/// returned by `StellarLocalizations.of(context)`.
///
/// Applications need to include `StellarLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/stellar_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: StellarLocalizations.localizationsDelegates,
///   supportedLocales: StellarLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the StellarLocalizations.supportedLocales
/// property.
abstract class StellarLocalizations {
  StellarLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static StellarLocalizations of(BuildContext context) {
    return Localizations.of<StellarLocalizations>(
      context,
      StellarLocalizations,
    )!;
  }

  static const LocalizationsDelegate<StellarLocalizations> delegate =
      _StellarLocalizationsDelegate();

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

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @errorNoConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorNoConnectionTitle;

  /// No description provided for @errorNoConnectionMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get errorNoConnectionMessage;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server is taking too long. Try again.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Try again in a moment.'**
  String get errorServer;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get errorUnknown;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found. It may have been removed.'**
  String get errorNotFound;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access to this.'**
  String get errorForbidden;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Log in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a minute and try again.'**
  String get errorRateLimited;

  /// No description provided for @errorPasswordChangeRequired.
  ///
  /// In en, this message translates to:
  /// **'Change your temporary password first.'**
  String get errorPasswordChangeRequired;

  /// No description provided for @errorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please check the details and try again.'**
  String get errorInvalid;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get validationRequired;

  /// No description provided for @validationMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least {count} characters'**
  String validationMinLength(int count);

  /// No description provided for @validationMaxLength.
  ///
  /// In en, this message translates to:
  /// **'At most {count} characters'**
  String validationMaxLength(int count);

  /// No description provided for @validationPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a Libyan mobile number, e.g. 0912345678'**
  String get validationPhone;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get validationEmail;

  /// No description provided for @validationUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid link starting with https://'**
  String get validationUrl;

  /// No description provided for @validationMustMatch.
  ///
  /// In en, this message translates to:
  /// **'Doesn\'t match'**
  String get validationMustMatch;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get updateRequiredTitle;

  /// No description provided for @updateRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'This version of the app is no longer supported. Update it from the store to continue.'**
  String get updateRequiredMessage;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @validationPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a price above 0, e.g. 4.500'**
  String get validationPrice;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'LD'**
  String get currency;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get choosePhoto;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get addPhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change the photo'**
  String get changePhoto;

  /// No description provided for @photoUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading… {percent}%'**
  String photoUploading(int percent);

  /// No description provided for @photoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'The photo didn\'t upload. Tap to try again.'**
  String get photoUploadFailed;

  /// No description provided for @photoFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t use this photo. Try another one.'**
  String get photoFailed;

  /// No description provided for @cameraOffTitle.
  ///
  /// In en, this message translates to:
  /// **'The camera is off'**
  String get cameraOffTitle;

  /// No description provided for @cameraOffMessage.
  ///
  /// In en, this message translates to:
  /// **'Allow the camera for this app in Settings to take photos.'**
  String get cameraOffMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @validationWholeNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number from {min} to {max}'**
  String validationWholeNumber(int min, int max);

  /// No description provided for @chooseDateTime.
  ///
  /// In en, this message translates to:
  /// **'Choose a day and time'**
  String get chooseDateTime;

  /// No description provided for @torchOn.
  ///
  /// In en, this message translates to:
  /// **'Turn the light on'**
  String get torchOn;

  /// No description provided for @torchOff.
  ///
  /// In en, this message translates to:
  /// **'Turn the light off'**
  String get torchOff;
}

class _StellarLocalizationsDelegate
    extends LocalizationsDelegate<StellarLocalizations> {
  const _StellarLocalizationsDelegate();

  @override
  Future<StellarLocalizations> load(Locale locale) {
    return SynchronousFuture<StellarLocalizations>(
      lookupStellarLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_StellarLocalizationsDelegate old) => false;
}

StellarLocalizations lookupStellarLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return StellarLocalizationsAr();
    case 'en':
      return StellarLocalizationsEn();
  }

  throw FlutterError(
    'StellarLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
