// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'customer_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class CustomerLocalizationsEn extends CustomerLocalizations {
  CustomerLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kaziony';

  @override
  String get homeTitle => 'Home';

  @override
  String get searchTitle => 'Search';

  @override
  String get bookingsTitle => 'My bookings';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get accountTitle => 'Account';

  @override
  String get helloTitle => 'Welcome to Kaziony';

  @override
  String get helloText => 'Offers from stores near you will be here soon.';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get signInMessage =>
      'To book offers and follow your favorite stores. You can browse without an account.';

  @override
  String get guestTitle => 'Welcome, dear guest!';

  @override
  String get guestMessage =>
      'Sign in to book offers before they run out and follow your favorite stores.';

  @override
  String get signInAction => 'Sign in';

  @override
  String get termsAgreement => 'By continuing you agree to the';

  @override
  String get termsTitle => 'Terms and Privacy Policy';

  @override
  String get termsSoonTitle => 'Coming soon';

  @override
  String get termsSoonMessage =>
      'The terms and privacy policy will be here before the app opens to everyone.';

  @override
  String get bookingsSignedOutTitle => 'Sign in to see your bookings';

  @override
  String get bookingsSignedOutMessage =>
      'Your bookings and pickup codes show up here.';

  @override
  String get appSection => 'App';

  @override
  String get logout => 'Log out';

  @override
  String get back => 'Back';

  @override
  String get tagline => 'Because good food shouldn\'t go to waste';

  @override
  String get helloMessage =>
      'Real offers from stores near you, in limited quantities. Book before they run out.';

  @override
  String get whyTitle => 'Why Kaziony?';

  @override
  String get whyLessWaste =>
      'Less food thrown away, more of it reaching people.';

  @override
  String get whySaveMoney => 'The same quality for less.';

  @override
  String get whyLocalStores => 'You support the stores in your neighborhood.';

  @override
  String get howTitle => 'How it works';

  @override
  String get howBook => 'Book the offer in the app.';

  @override
  String get howPickUp => 'Pick it up from the store on time.';

  @override
  String get howPay => 'Pay cash when you pick it up.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get started';

  @override
  String get locationTitle => 'Where are you?';

  @override
  String get locationMessage =>
      'We only show offers from stores near you. Stores never see your location.';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String get locationDenied =>
      'Location wasn\'t allowed. You can set your place on the map instead.';

  @override
  String get locationDeniedForever =>
      'Location is off for Kaziony. Allow it in Settings, or set your place on the map.';

  @override
  String get locationOff =>
      'Location is off on your phone. Turn it on, or set your place on the map.';

  @override
  String get locationFailed =>
      'We couldn\'t find your location. Try again, or set your place on the map.';

  @override
  String get myLocation => 'My current location';

  @override
  String get locationRow => 'Location';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get appleSignInSoon => 'Sign in with Apple is coming soon.';

  @override
  String get setOnMap => 'Set it on the map';

  @override
  String get mapTitle => 'Set your place';

  @override
  String get mapHint => 'Move the map until the pin is on your place.';

  @override
  String get confirmPlace => 'Confirm place';

  @override
  String get myLocationButton => 'My location';

  @override
  String get pinnedLocation => 'A place on the map';

  @override
  String get listSeparator => ', ';

  @override
  String outsideServiceArea(String areas) {
    return 'Kaziony is only in $areas for now.';
  }
}
