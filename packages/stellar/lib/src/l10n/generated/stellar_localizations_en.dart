// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'stellar_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class StellarLocalizationsEn extends StellarLocalizations {
  StellarLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get retry => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get loading => 'Loading…';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get errorNoConnectionTitle => 'No internet connection';

  @override
  String get errorNoConnectionMessage => 'Check your connection and try again.';

  @override
  String get errorTimeout => 'The server is taking too long. Try again.';

  @override
  String get errorServer =>
      'Something went wrong on our side. Try again in a moment.';

  @override
  String get errorUnknown => 'Something went wrong. Try again.';

  @override
  String get errorNotFound => 'Not found. It may have been removed.';

  @override
  String get errorForbidden => 'You don\'t have access to this.';

  @override
  String get errorUnauthorized => 'Your session has ended. Log in again.';

  @override
  String get errorRateLimited =>
      'Too many attempts. Wait a minute and try again.';

  @override
  String get errorPasswordChangeRequired =>
      'Change your temporary password first.';

  @override
  String get errorInvalid => 'Please check the details and try again.';

  @override
  String get validationRequired => 'Required';

  @override
  String validationMinLength(int count) {
    return 'At least $count characters';
  }

  @override
  String validationMaxLength(int count) {
    return 'At most $count characters';
  }

  @override
  String get validationPhone => 'Enter a Libyan mobile number, e.g. 0912345678';

  @override
  String get validationEmail => 'Enter a valid email';

  @override
  String get validationUrl => 'Enter a valid link starting with https://';

  @override
  String get validationMustMatch => 'Doesn\'t match';

  @override
  String get updateRequiredTitle => 'Update required';

  @override
  String get updateRequiredMessage =>
      'This version of the app is no longer supported. Update it from the store to continue.';

  @override
  String get close => 'Close';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get language => 'Language';

  @override
  String get languageHint => 'Choose the language the app shows in.';

  @override
  String get validationPrice => 'Enter a price above 0, e.g. 4.500';

  @override
  String get currency => 'LD';

  @override
  String get photo => 'Photo';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get choosePhoto => 'Choose from gallery';

  @override
  String get addPhoto => 'Add a photo';

  @override
  String get changePhoto => 'Change the photo';

  @override
  String get addPhotoHint => 'Clear, in good light';

  @override
  String photoUploading(int percent) {
    return 'Uploading… $percent%';
  }

  @override
  String get photoUploadFailed => 'The photo didn\'t upload. Tap to try again.';

  @override
  String get photoFailed => 'Couldn\'t use this photo. Try another one.';

  @override
  String get cameraOffTitle => 'The camera is off';

  @override
  String get cameraOffMessage =>
      'Allow the camera for this app in Settings to take photos.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String validationWholeNumber(int min, int max) {
    return 'Enter a whole number from $min to $max';
  }

  @override
  String get chooseDateTime => 'Choose a day and time';

  @override
  String get torchOn => 'Turn the light on';

  @override
  String get torchOff => 'Turn the light off';

  @override
  String get theme => 'Theme';

  @override
  String get themeHint =>
      'Choose how the app looks: light, dark, or like your phone.';

  @override
  String get themeSystem => 'Automatic';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';
}
