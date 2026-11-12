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

  /// No description provided for @offerFactPickup.
  ///
  /// In en, this message translates to:
  /// **'Pick up'**
  String get offerFactPickup;

  /// No description provided for @offerFactLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get offerFactLeft;

  /// No description provided for @offerFactLeftValue.
  ///
  /// In en, this message translates to:
  /// **'{left} of {total}'**
  String offerFactLeftValue(int left, int total);

  /// No description provided for @offerInfoToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get offerInfoToday;

  /// No description provided for @cardPickupBetween.
  ///
  /// In en, this message translates to:
  /// **'{day} {start} – {end}'**
  String cardPickupBetween(String day, String start, String end);

  /// No description provided for @cardPickupUntil.
  ///
  /// In en, this message translates to:
  /// **'{day} until {time}'**
  String cardPickupUntil(String day, String time);

  /// No description provided for @offerInfoTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get offerInfoTomorrow;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rated {average} out of 5 by {count, plural, =1{1 person} other{{count} people}}'**
  String ratingLabel(String average, int count);

  /// No description provided for @ratingStars.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 star} other{{count} stars}}'**
  String ratingStars(int count);

  /// No description provided for @ratingPrompt.
  ///
  /// In en, this message translates to:
  /// **'How was {store}?'**
  String ratingPrompt(String store);

  /// No description provided for @ratingPromptMessage.
  ///
  /// In en, this message translates to:
  /// **'Rate the store. It helps others choose.'**
  String get ratingPromptMessage;

  /// No description provided for @ratingGiven.
  ///
  /// In en, this message translates to:
  /// **'You rated {store}'**
  String ratingGiven(String store);

  /// No description provided for @ratingThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for rating!'**
  String get ratingThanks;

  /// No description provided for @ratingSend.
  ///
  /// In en, this message translates to:
  /// **'Send rating'**
  String get ratingSend;

  /// No description provided for @ratingNotPickedUp.
  ///
  /// In en, this message translates to:
  /// **'You can rate the store once you\'ve picked up.'**
  String get ratingNotPickedUp;

  /// No description provided for @ratingAlreadyRated.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already rated this store from this pickup or a later one.'**
  String get ratingAlreadyRated;

  /// No description provided for @ratingAgainMessage.
  ///
  /// In en, this message translates to:
  /// **'Picked up there again: rate it anew, and your new stars replace the old ones.'**
  String get ratingAgainMessage;

  /// No description provided for @ratingOnePerStore.
  ///
  /// In en, this message translates to:
  /// **'One rating per store. Pick up there again to change it.'**
  String get ratingOnePerStore;

  /// No description provided for @ratingUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update rating'**
  String get ratingUpdate;

  /// No description provided for @pickupInstructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pickup instructions'**
  String get pickupInstructionsTitle;

  /// No description provided for @pickupInstructionsDefault.
  ///
  /// In en, this message translates to:
  /// **'Show your pickup code to a staff member at the store, and they\'ll hand you your order.'**
  String get pickupInstructionsDefault;

  /// No description provided for @homeStoresNearby.
  ///
  /// In en, this message translates to:
  /// **'Stores near you'**
  String get homeStoresNearby;

  /// No description provided for @homeFavoriteStores.
  ///
  /// In en, this message translates to:
  /// **'Your favorite stores'**
  String get homeFavoriteStores;

  /// No description provided for @homeAllOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse every offer around you'**
  String get homeAllOffersTitle;

  /// No description provided for @homeAllOffersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 offer waiting, newest first} other{{count} offers waiting, newest first}}'**
  String homeAllOffersCount(int count);

  /// No description provided for @homeBannerRescueTitle.
  ///
  /// In en, this message translates to:
  /// **'Good food, saved before closing'**
  String get homeBannerRescueTitle;

  /// No description provided for @homeBannerRescueMessage.
  ///
  /// In en, this message translates to:
  /// **'What stores have left at the end of the day, for much less.'**
  String get homeBannerRescueMessage;

  /// No description provided for @homeBannerPickupTitle.
  ///
  /// In en, this message translates to:
  /// **'Reserve here, pick up there'**
  String get homeBannerPickupTitle;

  /// No description provided for @homeBannerPickupMessage.
  ///
  /// In en, this message translates to:
  /// **'Your offer waits for you at the store, just come and get it.'**
  String get homeBannerPickupMessage;

  /// No description provided for @homeBannerCashTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay cash at the store'**
  String get homeBannerCashTitle;

  /// No description provided for @homeBannerCashMessage.
  ///
  /// In en, this message translates to:
  /// **'No card needed: pay when you pick it up.'**
  String get homeBannerCashMessage;

  /// No description provided for @offerPageReserveCount.
  ///
  /// In en, this message translates to:
  /// **'Reserve {count}'**
  String offerPageReserveCount(int count);

  /// No description provided for @offerPageConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Reserve 1 piece?} other{Reserve {count} pieces?}}'**
  String offerPageConfirmTitle(int count);

  /// No description provided for @offerPageAbout.
  ///
  /// In en, this message translates to:
  /// **'About this offer'**
  String get offerPageAbout;

  /// No description provided for @offerPageGoodToKnow.
  ///
  /// In en, this message translates to:
  /// **'Good to know'**
  String get offerPageGoodToKnow;

  /// No description provided for @storeGetDirections.
  ///
  /// In en, this message translates to:
  /// **'Get directions'**
  String get storeGetDirections;

  /// No description provided for @storeDirectionsFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open the map. Try again.'**
  String get storeDirectionsFailed;

  /// No description provided for @openToday.
  ///
  /// In en, this message translates to:
  /// **'Open today {hours}'**
  String openToday(String hours);

  /// No description provided for @closedToday.
  ///
  /// In en, this message translates to:
  /// **'Closed today'**
  String get closedToday;

  /// No description provided for @storeClosesIn.
  ///
  /// In en, this message translates to:
  /// **'Closes in {time}'**
  String storeClosesIn(String time);

  /// No description provided for @storeClosedNow.
  ///
  /// In en, this message translates to:
  /// **'Closed now'**
  String get storeClosedNow;

  /// No description provided for @storeOpensAt.
  ///
  /// In en, this message translates to:
  /// **'Opens {when}'**
  String storeOpensAt(String when);

  /// No description provided for @hoursBetween.
  ///
  /// In en, this message translates to:
  /// **'{open} – {close}'**
  String hoursBetween(String open, String close);

  /// No description provided for @callAction.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get callAction;

  /// No description provided for @callFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t start the call. Try again.'**
  String get callFailed;

  /// No description provided for @storeAddFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get storeAddFavorite;

  /// No description provided for @storeRemoveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get storeRemoveFavorite;

  /// No description provided for @storeFavoriteSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save your favorite stores'**
  String get storeFavoriteSignInTitle;

  /// No description provided for @storeFavoriteSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Save the stores you like and find their offers in one place.'**
  String get storeFavoriteSignInMessage;

  /// No description provided for @storeOffersNow.
  ///
  /// In en, this message translates to:
  /// **'Offers now'**
  String get storeOffersNow;

  /// No description provided for @storeNoOffers.
  ///
  /// In en, this message translates to:
  /// **'No offers right now. Check back later.'**
  String get storeNoOffers;

  /// No description provided for @searchCraving.
  ///
  /// In en, this message translates to:
  /// **'What are you craving?'**
  String get searchCraving;

  /// No description provided for @searchRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get searchRecent;

  /// No description provided for @searchClearRecent.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get searchClearRecent;

  /// No description provided for @searchStoresNear.
  ///
  /// In en, this message translates to:
  /// **'Stores near you'**
  String get searchStoresNear;

  /// No description provided for @searchStores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get searchStores;

  /// No description provided for @searchOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get searchOffers;

  /// No description provided for @searchNoOffers.
  ///
  /// In en, this message translates to:
  /// **'No offers match right now.'**
  String get searchNoOffers;

  /// No description provided for @searchOffersNow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 offer now} other{{count} offers now}}'**
  String searchOffersNow(int count);

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

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTitle;

  /// No description provided for @signInMessage.
  ///
  /// In en, this message translates to:
  /// **'To book offers and save your favorite stores. You can browse without an account.'**
  String get signInMessage;

  /// No description provided for @guestTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome, dear guest!'**
  String get guestTitle;

  /// No description provided for @guestMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to book offers before they run out and save your favorite stores.'**
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

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About Kaziony'**
  String get aboutSection;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get greetingMorning;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening,'**
  String get greetingEvening;

  /// No description provided for @ratingsTitle.
  ///
  /// In en, this message translates to:
  /// **'My ratings'**
  String get ratingsTitle;

  /// No description provided for @ratingsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No ratings yet'**
  String get ratingsEmptyTitle;

  /// No description provided for @ratingsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Once you pick up, rate the store from your booking.'**
  String get ratingsEmptyMessage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Your bookings and favorite stores stay saved. Sign in again to see them.'**
  String get logoutMessage;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Your name, email, bookings, favorites and ratings are erased for good, and bookings you hold go back on sale. This can\'t be undone.'**
  String get deleteAccountMessage;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAccountConfirm;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account is deleted.'**
  String get accountDeleted;

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

  /// No description provided for @offersWithin.
  ///
  /// In en, this message translates to:
  /// **'Offers within {km} km'**
  String offersWithin(String km);

  /// No description provided for @offersNearby.
  ///
  /// In en, this message translates to:
  /// **'Offers nearby'**
  String get offersNearby;

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

  /// No description provided for @sectionAllOffers.
  ///
  /// In en, this message translates to:
  /// **'All offers'**
  String get sectionAllOffers;

  /// No description provided for @viewAsCards.
  ///
  /// In en, this message translates to:
  /// **'Show as cards'**
  String get viewAsCards;

  /// No description provided for @viewAsList.
  ///
  /// In en, this message translates to:
  /// **'Show as a list'**
  String get viewAsList;

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

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String distanceKm(String km);

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

  /// No description provided for @noResultsFor.
  ///
  /// In en, this message translates to:
  /// **'Nothing for “{words}” near you'**
  String noResultsFor(String words);

  /// No description provided for @noResultsNearby.
  ///
  /// In en, this message translates to:
  /// **'Stores post new offers every day. Here\'s what\'s near you now.'**
  String get noResultsNearby;

  /// No description provided for @holdTitle.
  ///
  /// In en, this message translates to:
  /// **'You have {time} to pick up'**
  String holdTitle(String time);

  /// No description provided for @holdMessage.
  ///
  /// In en, this message translates to:
  /// **'From when you reserve, and never past the offer\'s end.'**
  String get holdMessage;

  /// No description provided for @holdShort.
  ///
  /// In en, this message translates to:
  /// **'Less time'**
  String get holdShort;

  /// No description provided for @holdUntilClosing.
  ///
  /// In en, this message translates to:
  /// **'The store closes at {time}: pick up before then.'**
  String holdUntilClosing(String time);

  /// No description provided for @holdUntilOfferEnds.
  ///
  /// In en, this message translates to:
  /// **'The offer ends at {time}: pick up before then.'**
  String holdUntilOfferEnds(String time);

  /// No description provided for @bookingClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking opens when the store does'**
  String get bookingClosedTitle;

  /// No description provided for @bookingTooLateTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking has stopped: the store closes soon'**
  String get bookingTooLateTitle;

  /// No description provided for @bookingTooLateMessage.
  ///
  /// In en, this message translates to:
  /// **'The store closes at {time}, and booking stops {minutes} before.'**
  String bookingTooLateMessage(String time, String minutes);

  /// No description provided for @bookingClosedButton.
  ///
  /// In en, this message translates to:
  /// **'Closed now · opens {when}'**
  String bookingClosedButton(String when);

  /// No description provided for @bookingTooLateButton.
  ///
  /// In en, this message translates to:
  /// **'Too late to book · closes {time}'**
  String bookingTooLateButton(String time);

  /// No description provided for @reserveShortUntilClosing.
  ///
  /// In en, this message translates to:
  /// **'Only {time} to pick up: the store closes at {close}'**
  String reserveShortUntilClosing(String time, String close);

  /// No description provided for @reserveShortUntilEnd.
  ///
  /// In en, this message translates to:
  /// **'Only {time} to pick up: the offer ends at {end}'**
  String reserveShortUntilEnd(String time, String end);

  /// No description provided for @holdHours.
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, =1{1 hour} other{{hours} hours}}'**
  String holdHours(int hours);

  /// No description provided for @holdMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes, plural, =1{1 minute} other{{minutes} minutes}}'**
  String holdMinutes(int minutes);

  /// No description provided for @holdHoursAndMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} and {minutes}'**
  String holdHoursAndMinutes(String hours, String minutes);

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
  /// **'You have {time} to pick up, and you pay cash then.'**
  String reserveHoldNote(String time);

  /// No description provided for @reserveHoldUntilClosingNote.
  ///
  /// In en, this message translates to:
  /// **'You have {time} to pick up, until the store closes at {close}. You pay cash then.'**
  String reserveHoldUntilClosingNote(String time, String close);

  /// No description provided for @reserveHoldUntilEndNote.
  ///
  /// In en, this message translates to:
  /// **'You have {time} to pick up, until the offer ends at {end}. You pay cash then.'**
  String reserveHoldUntilEndNote(String time, String end);

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
  /// **'You already hold the most reservations at once. Pick one up or cancel one first.'**
  String get reserveTooMany;

  /// No description provided for @reserveFullNote.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You hold 1 reservation, the most at once. Pick it up or cancel it to book this one.} other{You hold {count} reservations, the most at once. Pick one up or cancel one to book this one.}}'**
  String reserveFullNote(int count);

  /// No description provided for @reserveCancelledTooOften.
  ///
  /// In en, this message translates to:
  /// **'You cancelled this offer twice, so you can\'t book it again.'**
  String get reserveCancelledTooOften;

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

  /// No description provided for @reserveStoreClosed.
  ///
  /// In en, this message translates to:
  /// **'The store is closed now. Book once it opens.'**
  String get reserveStoreClosed;

  /// No description provided for @reserveStoreClosingSoon.
  ///
  /// In en, this message translates to:
  /// **'The store closes too soon to get there in time.'**
  String get reserveStoreClosingSoon;

  /// No description provided for @reservePaused.
  ///
  /// In en, this message translates to:
  /// **'Booking is paused for a few days after missed pickups.'**
  String get reservePaused;

  /// No description provided for @bookingPausedUntil.
  ///
  /// In en, this message translates to:
  /// **'Booking paused until {when}'**
  String bookingPausedUntil(String when);

  /// No description provided for @bookingPausedMessage.
  ///
  /// In en, this message translates to:
  /// **'After missed pickups. It opens again by itself then.'**
  String get bookingPausedMessage;

  /// No description provided for @missedPickups.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You missed a pickup} other{You missed {count} pickups}}'**
  String missedPickups(int count);

  /// No description provided for @missedLeftBeforePause.
  ///
  /// In en, this message translates to:
  /// **'{left} more before booking pauses for {days, plural, =1{1 day} other{{days} days}}.'**
  String missedLeftBeforePause(int left, int days);

  /// No description provided for @missedFadesOn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{It stops counting on {date}.} other{The oldest stops counting on {date}.}}'**
  String missedFadesOn(int count, String date);

  /// No description provided for @missedLeftShort.
  ///
  /// In en, this message translates to:
  /// **'{left} more before a pause'**
  String missedLeftShort(int left);

  /// No description provided for @reserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved!'**
  String get reserved;

  /// No description provided for @bookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking details'**
  String get bookingTitle;

  /// No description provided for @qrLabel.
  ///
  /// In en, this message translates to:
  /// **'QR code to show at the store'**
  String get qrLabel;

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until {time}'**
  String validUntil(String time);

  /// No description provided for @bookingReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your booking is ready'**
  String get bookingReadyTitle;

  /// No description provided for @bookingReadyBanner.
  ///
  /// In en, this message translates to:
  /// **'Your booking is ready for pickup'**
  String get bookingReadyBanner;

  /// No description provided for @closeAction.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeAction;

  /// No description provided for @pickupTimeLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'Left to pick up'**
  String get pickupTimeLeftLabel;

  /// No description provided for @pickupUntilClosing.
  ///
  /// In en, this message translates to:
  /// **'Until the store closes at {time}'**
  String pickupUntilClosing(String time);

  /// No description provided for @oneCodeFor.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =2{One code for both pieces} other{One code for {count} pieces}}'**
  String oneCodeFor(int count);

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy the code'**
  String get copyCode;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get codeCopied;

  /// No description provided for @codeHint.
  ///
  /// In en, this message translates to:
  /// **'Show the code to the staff, or read them the letters if the camera can\'t scan it. Tap the code to copy it.'**
  String get codeHint;

  /// No description provided for @directionsAction.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directionsAction;

  /// No description provided for @pickupWhereTitle.
  ///
  /// In en, this message translates to:
  /// **'Where to pick up'**
  String get pickupWhereTitle;

  /// No description provided for @bookingsNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get bookingsNow;

  /// No description provided for @bookingsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get bookingsToday;

  /// No description provided for @bookingsYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get bookingsYesterday;

  /// No description provided for @pickUpBefore.
  ///
  /// In en, this message translates to:
  /// **'Pick up before {time}'**
  String pickUpBefore(String time);

  /// No description provided for @offerEndsLabel.
  ///
  /// In en, this message translates to:
  /// **'Offer ends'**
  String get offerEndsLabel;

  /// No description provided for @showCode.
  ///
  /// In en, this message translates to:
  /// **'Show pickup code'**
  String get showCode;

  /// No description provided for @payInCash.
  ///
  /// In en, this message translates to:
  /// **'Cash at pickup'**
  String get payInCash;

  /// No description provided for @factPieces.
  ///
  /// In en, this message translates to:
  /// **'Pieces'**
  String get factPieces;

  /// No description provided for @factTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get factTotal;

  /// No description provided for @factBookedAt.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get factBookedAt;

  /// No description provided for @factPickedUpAt.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get factPickedUpAt;

  /// No description provided for @payCashTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay cash at pickup'**
  String get payCashTitle;

  /// No description provided for @priceEach.
  ///
  /// In en, this message translates to:
  /// **'{count} × {price}'**
  String priceEach(int count, String price);

  /// No description provided for @cancelNoPenalty.
  ///
  /// In en, this message translates to:
  /// **'Cancel the booking (no penalty)'**
  String get cancelNoPenalty;

  /// No description provided for @quantityTimes.
  ///
  /// In en, this message translates to:
  /// **'×{count}'**
  String quantityTimes(int count);

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

  /// No description provided for @cancelEndsBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'The pieces go back to the offer. You cancelled it once already, so you won\'t be able to book this offer again.'**
  String get cancelEndsBookingMessage;

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

  /// No description provided for @bookingPickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked up. Enjoy!'**
  String get bookingPickedUp;

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

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorite stores yet'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on a store\'s page to keep it here.'**
  String get favoritesEmptyMessage;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'News about your bookings and your favorite stores will show up here.'**
  String get notificationsEmptyMessage;

  /// No description provided for @notificationsSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to get notifications'**
  String get notificationsSignInTitle;

  /// No description provided for @notificationsSignInMessage.
  ///
  /// In en, this message translates to:
  /// **'Know when a booking is about to run out and when your favorite stores post offers.'**
  String get notificationsSignInMessage;

  /// No description provided for @notificationBookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Your booking at {store} was cancelled'**
  String notificationBookingCancelled(String store);

  /// A notification's line: the offer, then what happened to it
  ///
  /// In en, this message translates to:
  /// **'{offer}. {why}'**
  String notificationAbout(String offer, String why);

  /// No description provided for @cancelledByUsTitle.
  ///
  /// In en, this message translates to:
  /// **'Kaziony cancelled this booking'**
  String get cancelledByUsTitle;

  /// No description provided for @cancelledOfferRemoved.
  ///
  /// In en, this message translates to:
  /// **'We took this offer down. This doesn\'t count against you.'**
  String get cancelledOfferRemoved;

  /// No description provided for @cancelledStoreOff.
  ///
  /// In en, this message translates to:
  /// **'This shop can\'t take bookings right now. This doesn\'t count against you.'**
  String get cancelledStoreOff;

  /// No description provided for @cancelledNotByYouTitle.
  ///
  /// In en, this message translates to:
  /// **'This booking was cancelled'**
  String get cancelledNotByYouTitle;

  /// No description provided for @cancelledNotByYou.
  ///
  /// In en, this message translates to:
  /// **'It wasn\'t your doing, so it doesn\'t count against you.'**
  String get cancelledNotByYou;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @browseOffers.
  ///
  /// In en, this message translates to:
  /// **'Browse offers'**
  String get browseOffers;

  /// No description provided for @placesTitle.
  ///
  /// In en, this message translates to:
  /// **'Show offers near'**
  String get placesTitle;

  /// No description provided for @addPlace.
  ///
  /// In en, this message translates to:
  /// **'Add a place'**
  String get addPlace;

  /// No description provided for @findingLocation.
  ///
  /// In en, this message translates to:
  /// **'Finding where you are…'**
  String get findingLocation;

  /// No description provided for @addPlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a place'**
  String get addPlaceTitle;

  /// No description provided for @addPlaceMessage.
  ///
  /// In en, this message translates to:
  /// **'Home, work, or family: save it once and switch with a tap.'**
  String get addPlaceMessage;

  /// No description provided for @placeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get placeNameLabel;

  /// No description provided for @placeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Home, Work, Grandma\'s'**
  String get placeNameHint;

  /// No description provided for @savePlace.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get savePlace;

  /// No description provided for @placeDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Name this place'**
  String get placeDetailsTitle;

  /// No description provided for @placeNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get placeNoteLabel;

  /// No description provided for @placeNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Second floor, across from the mosque'**
  String get placeNoteHint;

  /// No description provided for @editPlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit place'**
  String get editPlaceTitle;

  /// No description provided for @placeOnMap.
  ///
  /// In en, this message translates to:
  /// **'Spot on the map'**
  String get placeOnMap;

  /// No description provided for @placeMoved.
  ///
  /// In en, this message translates to:
  /// **'Moved'**
  String get placeMoved;

  /// No description provided for @deletePlace.
  ///
  /// In en, this message translates to:
  /// **'Delete place'**
  String get deletePlace;

  /// No description provided for @switchPlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch place?'**
  String get switchPlaceTitle;

  /// No description provided for @switchPlaceMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ll show offers near “{name}”.'**
  String switchPlaceMessage(String name);

  /// No description provided for @switchPlace.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchPlace;

  /// No description provided for @deletePlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”?'**
  String deletePlaceTitle(String name);

  /// No description provided for @deletePlaceMessage.
  ///
  /// In en, this message translates to:
  /// **'You can add it again any time.'**
  String get deletePlaceMessage;

  /// No description provided for @placesSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save your places'**
  String get placesSignInTitle;

  /// No description provided for @placeSaved.
  ///
  /// In en, this message translates to:
  /// **'Place saved'**
  String get placeSaved;

  /// No description provided for @placeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Place updated'**
  String get placeUpdated;

  /// No description provided for @placeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Place deleted'**
  String get placeDeleted;

  /// No description provided for @statusOutForDelivery.
  ///
  /// In en, this message translates to:
  /// **'On its way'**
  String get statusOutForDelivery;

  /// No description provided for @withTheStoresDriver.
  ///
  /// In en, this message translates to:
  /// **'With the store\'s driver'**
  String get withTheStoresDriver;

  /// No description provided for @bookingOnItsWayBanner.
  ///
  /// In en, this message translates to:
  /// **'Your booking is on its way'**
  String get bookingOnItsWayBanner;

  /// No description provided for @bookingOnItsWayTitle.
  ///
  /// In en, this message translates to:
  /// **'Your booking is on its way'**
  String get bookingOnItsWayTitle;

  /// No description provided for @bookingDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered. Enjoy!'**
  String get bookingDelivered;

  /// No description provided for @bookingSentForDelivery.
  ///
  /// In en, this message translates to:
  /// **'The store\'s driver has your booking.'**
  String get bookingSentForDelivery;

  /// No description provided for @cancelByCallingStore.
  ///
  /// In en, this message translates to:
  /// **'To cancel, call the store'**
  String get cancelByCallingStore;

  /// No description provided for @payDriverTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay the driver in cash'**
  String get payDriverTitle;

  /// No description provided for @callAboutDelivery.
  ///
  /// In en, this message translates to:
  /// **'Call about your delivery'**
  String get callAboutDelivery;

  /// No description provided for @storeDelivers.
  ///
  /// In en, this message translates to:
  /// **'This shop delivers'**
  String get storeDelivers;

  /// No description provided for @storeDeliversHint.
  ///
  /// In en, this message translates to:
  /// **'Call {phone} and read them your code. Delivery and any fee are arranged with the store.'**
  String storeDeliversHint(String phone);

  /// No description provided for @onItsWaySince.
  ///
  /// In en, this message translates to:
  /// **'With the store\'s driver since {time}'**
  String onItsWaySince(String time);

  /// No description provided for @factDeliveredAt.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get factDeliveredAt;

  /// No description provided for @cancelledNotDeliveredTitle.
  ///
  /// In en, this message translates to:
  /// **'The store cancelled this delivery'**
  String get cancelledNotDeliveredTitle;

  /// No description provided for @cancelledNotDelivered.
  ///
  /// In en, this message translates to:
  /// **'The store says the delivery didn\'t happen. This doesn\'t count against you.'**
  String get cancelledNotDelivered;
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
