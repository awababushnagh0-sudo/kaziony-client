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

  /// No description provided for @reserveSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to reserve'**
  String get reserveSignInTitle;

  /// No description provided for @reserveSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Hold the offer now and pick it up at the store. It only takes a moment.'**
  String get reserveSignInMessage;

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

  /// No description provided for @offersNear.
  ///
  /// In en, this message translates to:
  /// **'Offers near'**
  String get offersNear;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a store or an offer'**
  String get searchHint;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @bannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Good food, for less'**
  String get bannerTitle;

  /// No description provided for @bannerMessage.
  ///
  /// In en, this message translates to:
  /// **'Reserve an offer, pick it up at the store and pay cash there.'**
  String get bannerMessage;

  /// No description provided for @bannerTag.
  ///
  /// In en, this message translates to:
  /// **'Because good food shouldn\'t go to waste'**
  String get bannerTag;

  /// No description provided for @sectionEndingSoon.
  ///
  /// In en, this message translates to:
  /// **'Ending soon'**
  String get sectionEndingSoon;

  /// No description provided for @sectionNearby.
  ///
  /// In en, this message translates to:
  /// **'Near you'**
  String get sectionNearby;

  /// No description provided for @sectionBiggestDiscount.
  ///
  /// In en, this message translates to:
  /// **'Biggest discounts'**
  String get sectionBiggestDiscount;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @noOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'No offers near you right now'**
  String get noOffersTitle;

  /// No description provided for @noOffersMessage.
  ///
  /// In en, this message translates to:
  /// **'Stores post offers during the day. Check back soon or change the place.'**
  String get noOffersMessage;

  /// No description provided for @changePlace.
  ///
  /// In en, this message translates to:
  /// **'Change the place'**
  String get changePlace;

  /// No description provided for @discountOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String discountOff(int percent);

  /// No description provided for @piecesLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String piecesLeft(int count);

  /// No description provided for @piecesOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{left} of {total} left'**
  String piecesOfTotal(int left, int total);

  /// No description provided for @endsInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Ends in {minutes} min'**
  String endsInMinutes(int minutes);

  /// No description provided for @endsAtTime.
  ///
  /// In en, this message translates to:
  /// **'Until {time}'**
  String endsAtTime(String time);

  /// No description provided for @endsOnDay.
  ///
  /// In en, this message translates to:
  /// **'Until {day}'**
  String endsOnDay(String day);

  /// No description provided for @endsTodayAt.
  ///
  /// In en, this message translates to:
  /// **'Ends today at {time}'**
  String endsTodayAt(String time);

  /// No description provided for @endsOn.
  ///
  /// In en, this message translates to:
  /// **'Ends {date}'**
  String endsOn(String date);

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String distanceKm(String km);

  /// No description provided for @offersTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offersTitle;

  /// No description provided for @sortNearest.
  ///
  /// In en, this message translates to:
  /// **'Nearest'**
  String get sortNearest;

  /// No description provided for @sortEndingSoon.
  ///
  /// In en, this message translates to:
  /// **'Ending soon'**
  String get sortEndingSoon;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortBiggestDiscount.
  ///
  /// In en, this message translates to:
  /// **'Biggest discount'**
  String get sortBiggestDiscount;

  /// No description provided for @sortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort offers'**
  String get sortTitle;

  /// No description provided for @noResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get noResultsTitle;

  /// No description provided for @noResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try another word or category.'**
  String get noResultsMessage;

  /// No description provided for @holdTitle.
  ///
  /// In en, this message translates to:
  /// **'Held for you for {minutes} min'**
  String holdTitle(int minutes);

  /// No description provided for @holdMessage.
  ///
  /// In en, this message translates to:
  /// **'Reserve now and pick it up at the store within that time.'**
  String get holdMessage;

  /// No description provided for @untilEndTitle.
  ///
  /// In en, this message translates to:
  /// **'Your code works until the offer ends'**
  String get untilEndTitle;

  /// No description provided for @untilEndMessage.
  ///
  /// In en, this message translates to:
  /// **'Pick it up any time before the offer ends.'**
  String get untilEndMessage;

  /// No description provided for @payTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay cash at the store'**
  String get payTitle;

  /// No description provided for @payMessage.
  ///
  /// In en, this message translates to:
  /// **'You pay nothing now.'**
  String get payMessage;

  /// No description provided for @pickupOne.
  ///
  /// In en, this message translates to:
  /// **'Pick up at the branch'**
  String get pickupOne;

  /// No description provided for @pickupAny.
  ///
  /// In en, this message translates to:
  /// **'Pick up at any branch'**
  String get pickupAny;

  /// No description provided for @limitPerCustomer.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} per customer'**
  String limitPerCustomer(int count);

  /// No description provided for @reserveNow.
  ///
  /// In en, this message translates to:
  /// **'Reserve now'**
  String get reserveNow;

  /// No description provided for @showMyCode.
  ///
  /// In en, this message translates to:
  /// **'Show my pickup code'**
  String get showMyCode;

  /// No description provided for @soldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold out'**
  String get soldOut;

  /// No description provided for @reserveTitle.
  ///
  /// In en, this message translates to:
  /// **'How many?'**
  String get reserveTitle;

  /// No description provided for @pricePerPiece.
  ///
  /// In en, this message translates to:
  /// **'{price} each'**
  String pricePerPiece(String price);

  /// No description provided for @reserveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm reservation'**
  String get reserveConfirm;

  /// No description provided for @reserveHoldNote.
  ///
  /// In en, this message translates to:
  /// **'We hold them for {minutes} min. You pay cash when you pick up.'**
  String reserveHoldNote(int minutes);

  /// No description provided for @reserveUntilEndNote.
  ///
  /// In en, this message translates to:
  /// **'Your code works until the offer ends. You pay cash when you pick up.'**
  String get reserveUntilEndNote;

  /// No description provided for @reserveAlreadyReserved.
  ///
  /// In en, this message translates to:
  /// **'You already have a reservation for this offer.'**
  String get reserveAlreadyReserved;

  /// No description provided for @reserveLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already taken the most this offer allows.'**
  String get reserveLimitReached;

  /// No description provided for @reserveOverLimit.
  ///
  /// In en, this message translates to:
  /// **'You can\'t take that many. Try fewer.'**
  String get reserveOverLimit;

  /// No description provided for @reserveTooMany.
  ///
  /// In en, this message translates to:
  /// **'You have too many reservations. Pick one up or cancel one first.'**
  String get reserveTooMany;

  /// No description provided for @reserveNotEnough.
  ///
  /// In en, this message translates to:
  /// **'There aren\'t that many left. Try fewer.'**
  String get reserveNotEnough;

  /// No description provided for @reserveNotStarted.
  ///
  /// In en, this message translates to:
  /// **'This offer hasn\'t started yet.'**
  String get reserveNotStarted;

  /// No description provided for @reserveEnded.
  ///
  /// In en, this message translates to:
  /// **'This offer has ended.'**
  String get reserveEnded;

  /// No description provided for @reserveBanned.
  ///
  /// In en, this message translates to:
  /// **'You missed several pickups, so you can\'t reserve for a few days.'**
  String get reserveBanned;

  /// No description provided for @reserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved!'**
  String get reserved;

  /// No description provided for @bookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pickup code'**
  String get bookingTitle;

  /// No description provided for @qrLabel.
  ///
  /// In en, this message translates to:
  /// **'QR code to show at the store'**
  String get qrLabel;

  /// No description provided for @showAtCounter.
  ///
  /// In en, this message translates to:
  /// **'Show this at the counter'**
  String get showAtCounter;

  /// No description provided for @timeLeftToPickUp.
  ///
  /// In en, this message translates to:
  /// **'{time} left to pick up'**
  String timeLeftToPickUp(String time);

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until {time}'**
  String validUntil(String time);

  /// No description provided for @payAtCounter.
  ///
  /// In en, this message translates to:
  /// **'Pay {price} cash when you pick up'**
  String payAtCounter(String price);

  /// No description provided for @quantityTimes.
  ///
  /// In en, this message translates to:
  /// **'×{count}'**
  String quantityTimes(int count);

  /// No description provided for @pickUpAt.
  ///
  /// In en, this message translates to:
  /// **'Pick up at'**
  String get pickUpAt;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel reservation'**
  String get cancelBooking;

  /// No description provided for @cancelBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this reservation?'**
  String get cancelBookingTitle;

  /// No description provided for @cancelBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'The pieces go back to the offer, and it doesn\'t count against you.'**
  String get cancelBookingMessage;

  /// No description provided for @keepBooking.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get keepBooking;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Reservation cancelled'**
  String get bookingCancelled;

  /// No description provided for @statusReserved.
  ///
  /// In en, this message translates to:
  /// **'Waiting for pickup'**
  String get statusReserved;

  /// No description provided for @statusPickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get statusPickedUp;

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Time ran out'**
  String get statusExpired;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @bookingsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reservations yet'**
  String get bookingsEmptyTitle;

  /// No description provided for @bookingsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Reserve an offer and its pickup code shows up here.'**
  String get bookingsEmptyMessage;

  /// No description provided for @browseOffers.
  ///
  /// In en, this message translates to:
  /// **'Browse offers'**
  String get browseOffers;
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
