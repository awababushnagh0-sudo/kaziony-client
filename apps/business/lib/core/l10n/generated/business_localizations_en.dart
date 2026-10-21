// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'business_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class BusinessLocalizationsEn extends BusinessLocalizations {
  BusinessLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Offers for Stores';

  @override
  String get switchLanguage => 'العربية';

  @override
  String get loginTitle => 'Store login';

  @override
  String get loginSubtitle =>
      'Use the phone number and password you got from our team.';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Log in';

  @override
  String get wrongCredentials => 'Wrong phone number or password.';

  @override
  String get accountDisabled => 'This account is disabled. Contact us.';

  @override
  String get sessionExpired => 'Your session ended. Please log in again.';

  @override
  String get notStoreAccount => 'This app is for store accounts only.';

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
  String get branchesTitle => 'Branches';

  @override
  String get storeActive => 'Active';

  @override
  String get storeDisabled => 'Disabled. Contact us to re-enable it.';

  @override
  String get branchClosed => 'Closed';

  @override
  String get cityTripoli => 'Tripoli';

  @override
  String get ownerRole => 'Owner';

  @override
  String get staffRole => 'Staff';

  @override
  String get noStoreTitle => 'No store is linked to this account';

  @override
  String get noStoreMessage => 'Contact our team to set up your store.';

  @override
  String get comingNext => 'Products and offers are coming next.';
}
