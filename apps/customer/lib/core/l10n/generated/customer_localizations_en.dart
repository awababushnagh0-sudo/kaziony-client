// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'customer_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class CustomerLocalizationsEn extends CustomerLocalizations {
  CustomerLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get offerFactPickup => 'Pick up';

  @override
  String get offerFactLeft => 'Left';

  @override
  String offerFactLeftValue(int left, int total) {
    return '$left of $total';
  }

  @override
  String get offerInfoToday => 'Today';

  @override
  String cardPickupBetween(String day, String start, String end) {
    return '$day $start – $end';
  }

  @override
  String cardPickupUntil(String day, String time) {
    return '$day until $time';
  }

  @override
  String get offerInfoTomorrow => 'Tomorrow';

  @override
  String ratingLabel(String average, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return 'Rated $average out of 5 by $_temp0';
  }

  @override
  String ratingStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars',
      one: '1 star',
    );
    return '$_temp0';
  }

  @override
  String ratingPrompt(String store) {
    return 'How was $store?';
  }

  @override
  String get ratingPromptMessage => 'Rate the store. It helps others choose.';

  @override
  String ratingGiven(String store) {
    return 'You rated $store';
  }

  @override
  String get ratingThanks => 'Thanks for rating!';

  @override
  String get ratingSend => 'Send rating';

  @override
  String get ratingNotPickedUp =>
      'You can rate the store once you\'ve picked up.';

  @override
  String get ratingAlreadyRated =>
      'You\'ve already rated this store from this pickup or a later one.';

  @override
  String get ratingAgainMessage =>
      'Picked up there again: rate it anew, and your new stars replace the old ones.';

  @override
  String get ratingOnePerStore =>
      'One rating per store. Pick up there again to change it.';

  @override
  String get ratingUpdate => 'Update rating';

  @override
  String get pickupInstructionsTitle => 'Pickup instructions';

  @override
  String get pickupInstructionsDefault =>
      'Show your pickup code to a staff member at the store, and they\'ll hand you your order.';

  @override
  String get homeStoresNearby => 'Stores near you';

  @override
  String get homeFavoriteStores => 'Your favorite stores';

  @override
  String get homeAllOffersTitle => 'Browse every offer around you';

  @override
  String homeAllOffersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count offers waiting, newest first',
      one: '1 offer waiting, newest first',
    );
    return '$_temp0';
  }

  @override
  String get homeBannerRescueTitle => 'Good food, saved before closing';

  @override
  String get homeBannerRescueMessage =>
      'What stores have left at the end of the day, for much less.';

  @override
  String get homeBannerPickupTitle => 'Reserve here, pick up there';

  @override
  String get homeBannerPickupMessage =>
      'Your offer waits for you at the store, just come and get it.';

  @override
  String get homeBannerCashTitle => 'Pay cash at the store';

  @override
  String get homeBannerCashMessage =>
      'No card needed: pay when you pick it up.';

  @override
  String offerPageReserveCount(int count) {
    return 'Reserve $count';
  }

  @override
  String offerPageConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reserve $count pieces?',
      one: 'Reserve 1 piece?',
    );
    return '$_temp0';
  }

  @override
  String get offerPageAbout => 'About this offer';

  @override
  String get offerPageGoodToKnow => 'Good to know';

  @override
  String get storeGetDirections => 'Get directions';

  @override
  String get storeDirectionsFailed => 'We couldn\'t open the map. Try again.';

  @override
  String openToday(String hours) {
    return 'Open today $hours';
  }

  @override
  String get closedToday => 'Closed today';

  @override
  String storeClosesIn(String time) {
    return 'Closes in $time';
  }

  @override
  String storeClosesInShort(int minutes) {
    return 'Closes in $minutes min';
  }

  @override
  String get storeClosedNow => 'Closed now';

  @override
  String storeOpensAt(String when) {
    return 'Opens $when';
  }

  @override
  String hoursBetween(String open, String close) {
    return '$open – $close';
  }

  @override
  String get callAction => 'Call';

  @override
  String get callFailed => 'We couldn\'t start the call. Try again.';

  @override
  String get storeAddFavorite => 'Add to favorites';

  @override
  String get storeRemoveFavorite => 'Remove from favorites';

  @override
  String get storeFavoriteSignInTitle => 'Sign in to save your favorite stores';

  @override
  String get storeFavoriteSignInMessage =>
      'Save the stores you like and find their offers in one place.';

  @override
  String get storeOffersNow => 'Offers now';

  @override
  String get storeNoOffers => 'No offers right now. Check back later.';

  @override
  String get searchCraving => 'What are you craving?';

  @override
  String get searchRecent => 'Recent searches';

  @override
  String get searchClearRecent => 'Clear';

  @override
  String get searchStoresNear => 'Stores near you';

  @override
  String get searchStores => 'Stores';

  @override
  String get searchOffers => 'Offers';

  @override
  String get searchNoOffers => 'No offers match right now.';

  @override
  String searchOffersNow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count offers now',
      one: '1 offer now',
    );
    return '$_temp0';
  }

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
  String get signInTitle => 'Sign in';

  @override
  String get signInMessage =>
      'To book offers and save your favorite stores. You can browse without an account.';

  @override
  String get guestTitle => 'Welcome, dear guest!';

  @override
  String get guestMessage =>
      'Sign in to book offers before they run out and save your favorite stores.';

  @override
  String get reserveSignInTitle => 'Sign in to reserve';

  @override
  String get reserveSignInMessage =>
      'Hold the offer now and pick it up at the store. It only takes a moment.';

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
  String get aboutSection => 'About Kaziony';

  @override
  String get greetingMorning => 'Good morning,';

  @override
  String get greetingEvening => 'Good evening,';

  @override
  String get ratingsTitle => 'My ratings';

  @override
  String get ratingsEmptyTitle => 'No ratings yet';

  @override
  String get ratingsEmptyMessage =>
      'Once you pick up, rate the store from your booking.';

  @override
  String get logout => 'Log out';

  @override
  String get logoutTitle => 'Log out?';

  @override
  String get logoutMessage =>
      'Your bookings and favorite stores stay saved. Sign in again to see them.';

  @override
  String get deleteAccount => 'Delete my account';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountMessage =>
      'Your name, email, bookings, favorites and ratings are erased for good, and bookings you hold go back on sale. This can\'t be undone.';

  @override
  String get deleteAccountConfirm => 'Delete';

  @override
  String get accountDeleted => 'Your account is deleted.';

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

  @override
  String offersWithin(String km) {
    return 'Offers within $km km';
  }

  @override
  String get offersNearby => 'Offers nearby';

  @override
  String get searchHint => 'Search for a store or an offer';

  @override
  String get allCategories => 'All';

  @override
  String get sectionEndingSoon => 'Ending soon';

  @override
  String get sectionNearby => 'Near you';

  @override
  String get sectionBiggestDiscount => 'Biggest discounts';

  @override
  String get sectionAllOffers => 'All offers';

  @override
  String get viewAsCards => 'Show as cards';

  @override
  String get viewAsList => 'Show as a list';

  @override
  String get seeAll => 'See all';

  @override
  String get noOffersTitle => 'No offers near you right now';

  @override
  String get noOffersMessage =>
      'Stores post offers during the day. Check back soon or change the place.';

  @override
  String get changePlace => 'Change the place';

  @override
  String discountOff(int percent) {
    return '$percent% off';
  }

  @override
  String piecesLeft(int count) {
    return '$count left';
  }

  @override
  String distanceKm(String km) {
    return '$km km';
  }

  @override
  String get sortNearest => 'Nearest';

  @override
  String get sortEndingSoon => 'Ending soon';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortBiggestDiscount => 'Biggest discount';

  @override
  String get sortTitle => 'Sort offers';

  @override
  String get noResultsTitle => 'Nothing found';

  @override
  String get noResultsMessage => 'Try another word or category.';

  @override
  String noResultsFor(String words) {
    return 'Nothing for “$words” near you';
  }

  @override
  String get noResultsNearby =>
      'Stores post new offers every day. Here\'s what\'s near you now.';

  @override
  String holdTitle(String time) {
    return 'You have $time to pick up';
  }

  @override
  String get holdMessage =>
      'From when you reserve, and never past the offer\'s end.';

  @override
  String get holdShort => 'Less time';

  @override
  String holdUntilClosing(String time, String close) {
    return 'Last pickup $time, before the store closes at $close.';
  }

  @override
  String holdUntilOfferEnds(String time) {
    return 'The offer ends at $time: pick up before then.';
  }

  @override
  String get bookingClosedTitle => 'Booking opens when the store does';

  @override
  String get bookingTooLateTitle =>
      'Booking has stopped: the store closes soon';

  @override
  String bookingTooLateMessage(String time, String minutes) {
    return 'The store closes at $time, and booking stops $minutes before.';
  }

  @override
  String get bookingClosedNote => 'The store is closed now';

  @override
  String get bookingTooLateNote => 'Too late to book';

  @override
  String bookingTooLateNoteMessage(String time) {
    return 'The store closes at $time';
  }

  @override
  String reserveShortUntilClosing(String time, String close) {
    return 'Only $time to pick up: last pickup $close';
  }

  @override
  String reserveShortUntilEnd(String time, String end) {
    return 'Only $time to pick up: the offer ends at $end';
  }

  @override
  String holdHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String holdMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String holdHoursAndMinutes(String hours, String minutes) {
    return '$hours and $minutes';
  }

  @override
  String get untilEndTitle => 'Your code works until the offer ends';

  @override
  String get untilEndMessage => 'Pick it up any time before the offer ends.';

  @override
  String get payTitle => 'Pay cash at the store';

  @override
  String get payMessage => 'You pay nothing now.';

  @override
  String limitPerCustomer(int count) {
    return 'Up to $count per customer';
  }

  @override
  String get reserveNow => 'Reserve now';

  @override
  String get showMyCode => 'Show my pickup code';

  @override
  String get soldOut => 'Sold out';

  @override
  String pricePerPiece(String price) {
    return '$price each';
  }

  @override
  String get reserveConfirm => 'Confirm reservation';

  @override
  String reserveHoldNote(String time) {
    return 'You have $time to pick up, and you pay cash then.';
  }

  @override
  String reserveHoldUntilClosingNote(String time, String close) {
    return 'You have $time to pick up: the last pickup is $close, before the store closes. You pay cash then.';
  }

  @override
  String reserveHoldUntilEndNote(String time, String end) {
    return 'You have $time to pick up, until the offer ends at $end. You pay cash then.';
  }

  @override
  String get reserveUntilEndNote =>
      'Your code works until the offer ends. You pay cash when you pick up.';

  @override
  String get reserveAlreadyReserved =>
      'You already have a reservation for this offer.';

  @override
  String get reserveLimitReached =>
      'You\'ve already taken the most this offer allows.';

  @override
  String get reserveOverLimit => 'You can\'t take that many. Try fewer.';

  @override
  String get reserveTooMany =>
      'You already hold the most reservations at once. Pick one up or cancel one first.';

  @override
  String reserveFullNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'You hold $count reservations, the most at once. Pick one up or cancel one to book this one.',
      one: 'You hold 1 reservation, the most at once. Pick it up or cancel it to book this one.',
    );
    return '$_temp0';
  }

  @override
  String get reserveCancelledTooOften =>
      'You cancelled this offer twice, so you can\'t book it again.';

  @override
  String get reserveNotEnough => 'There aren\'t that many left. Try fewer.';

  @override
  String get reserveNotStarted => 'This offer hasn\'t started yet.';

  @override
  String get reserveEnded => 'This offer has ended.';

  @override
  String get reserveStoreClosed =>
      'The store is closed now. Book once it opens.';

  @override
  String get reserveStoreClosingSoon =>
      'The store closes too soon to get there in time.';

  @override
  String get reservePaused =>
      'Booking is paused for a few days after missed pickups.';

  @override
  String bookingPausedUntil(String when) {
    return 'Booking paused until $when';
  }

  @override
  String get bookingPausedMessage =>
      'After missed pickups. It opens again by itself then.';

  @override
  String missedPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You missed $count pickups',
      one: 'You missed a pickup',
    );
    return '$_temp0';
  }

  @override
  String missedLeftBeforePause(int left, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$left more before booking pauses for $_temp0.';
  }

  @override
  String missedFadesOn(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'The oldest stops counting on $date.',
      one: 'It stops counting on $date.',
    );
    return '$_temp0';
  }

  @override
  String missedLeftShort(int left) {
    return '$left more before a pause';
  }

  @override
  String get reserved => 'Reserved!';

  @override
  String get bookingTitle => 'Booking details';

  @override
  String get qrLabel => 'QR code to show at the store';

  @override
  String validUntil(String time) {
    return 'Valid until $time';
  }

  @override
  String get bookingReadyTitle => 'Your booking is ready';

  @override
  String get bookingReadyBanner => 'Your booking is ready for pickup';

  @override
  String get closeAction => 'Close';

  @override
  String get pickupTimeLeftLabel => 'Left to pick up';

  @override
  String pickupUntilClosing(String time) {
    return 'Until the store closes at $time';
  }

  @override
  String oneCodeFor(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'One code for $count pieces',
      two: 'One code for both pieces',
    );
    return '$_temp0';
  }

  @override
  String get copyCode => 'Copy the code';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get codeHint =>
      'Show the code to the staff, or read them the letters if the camera can\'t scan it. Tap the code to copy it.';

  @override
  String get directionsAction => 'Directions';

  @override
  String get pickupWhereTitle => 'Where to pick up';

  @override
  String get bookingsNow => 'Now';

  @override
  String get bookingsToday => 'Today';

  @override
  String get bookingsYesterday => 'Yesterday';

  @override
  String pickUpBefore(String time) {
    return 'Pick up before $time';
  }

  @override
  String get offerEndsLabel => 'Offer ends';

  @override
  String get showCode => 'Show pickup code';

  @override
  String get payInCash => 'Cash at pickup';

  @override
  String get factPieces => 'Pieces';

  @override
  String get factTotal => 'Total';

  @override
  String get factBookedAt => 'Booked';

  @override
  String get factPickedUpAt => 'Picked up';

  @override
  String get payCashTitle => 'Pay cash at pickup';

  @override
  String priceEach(int count, String price) {
    return '$count × $price';
  }

  @override
  String get cancelNoPenalty => 'Cancel the booking (no penalty)';

  @override
  String quantityTimes(int count) {
    return '×$count';
  }

  @override
  String get cancelBooking => 'Cancel reservation';

  @override
  String get cancelBookingTitle => 'Cancel this reservation?';

  @override
  String get cancelBookingMessage =>
      'The pieces go back to the offer, and it doesn\'t count against you.';

  @override
  String get cancelEndsBookingMessage =>
      'The pieces go back to the offer. You cancelled it once already, so you won\'t be able to book this offer again.';

  @override
  String get keepBooking => 'Keep it';

  @override
  String get bookingCancelled => 'Reservation cancelled';

  @override
  String get bookingPickedUp => 'Picked up. Enjoy!';

  @override
  String get statusReserved => 'Waiting for pickup';

  @override
  String get statusPickedUp => 'Picked up';

  @override
  String get statusExpired => 'Time ran out';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get bookingsEmptyTitle => 'No reservations yet';

  @override
  String get bookingsEmptyMessage =>
      'Reserve an offer and its pickup code shows up here.';

  @override
  String get favoritesEmptyTitle => 'No favorite stores yet';

  @override
  String get favoritesEmptyMessage =>
      'Tap the heart on a store\'s page to keep it here.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmptyTitle => 'No notifications yet';

  @override
  String get notificationsEmptyMessage =>
      'News about your bookings and your favorite stores will show up here.';

  @override
  String get notificationsSignInTitle => 'Sign in to get notifications';

  @override
  String get notificationsSignInMessage =>
      'Know when a booking is about to run out and when your favorite stores post offers.';

  @override
  String notificationBookingCancelled(String store) {
    return 'Your booking at $store was cancelled';
  }

  @override
  String notificationAbout(String offer, String why) {
    return '$offer. $why';
  }

  @override
  String get cancelledByUsTitle => 'Kaziony cancelled this booking';

  @override
  String get cancelledOfferRemoved =>
      'We took this offer down. This doesn\'t count against you.';

  @override
  String get cancelledStoreOff =>
      'This shop can\'t take bookings right now. This doesn\'t count against you.';

  @override
  String get cancelledNotByYouTitle => 'This booking was cancelled';

  @override
  String get cancelledNotByYou =>
      'It wasn\'t your doing, so it doesn\'t count against you.';

  @override
  String get refresh => 'Refresh';

  @override
  String get browseOffers => 'Browse offers';

  @override
  String get placesTitle => 'Show offers near';

  @override
  String get addPlace => 'Add a place';

  @override
  String get findingLocation => 'Finding where you are…';

  @override
  String get addPlaceTitle => 'Add a place';

  @override
  String get addPlaceMessage =>
      'Home, work, or family: save it once and switch with a tap.';

  @override
  String get placeNameLabel => 'Name';

  @override
  String get placeNameHint => 'e.g. Home, Work, Grandma\'s';

  @override
  String get savePlace => 'Save';

  @override
  String get placeDetailsTitle => 'Name this place';

  @override
  String get placeNoteLabel => 'Description (optional)';

  @override
  String get placeNoteHint => 'e.g. Second floor, across from the mosque';

  @override
  String get editPlaceTitle => 'Edit place';

  @override
  String get placeOnMap => 'Spot on the map';

  @override
  String get placeMoved => 'Moved';

  @override
  String get deletePlace => 'Delete place';

  @override
  String get switchPlaceTitle => 'Switch place?';

  @override
  String switchPlaceMessage(String name) {
    return 'We\'ll show offers near “$name”.';
  }

  @override
  String get switchPlace => 'Switch';

  @override
  String deletePlaceTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String get deletePlaceMessage => 'You can add it again any time.';

  @override
  String get placesSignInTitle => 'Sign in to save your places';

  @override
  String get placeSaved => 'Place saved';

  @override
  String get placeUpdated => 'Place updated';

  @override
  String get placeDeleted => 'Place deleted';

  @override
  String get statusOutForDelivery => 'On its way';

  @override
  String get withTheStoresDriver => 'With the store\'s driver';

  @override
  String get bookingOnItsWayBanner => 'Your booking is on its way';

  @override
  String get bookingOnItsWayTitle => 'Your booking is on its way';

  @override
  String get bookingDelivered => 'Delivered. Enjoy!';

  @override
  String get bookingSentForDelivery => 'The store\'s driver has your booking.';

  @override
  String get cancelByCallingStore => 'To cancel, call the store';

  @override
  String get payDriverTitle => 'Pay the driver in cash';

  @override
  String get callAboutDelivery => 'Call about your delivery';

  @override
  String get storeDelivers => 'This shop delivers';

  @override
  String storeDeliversHint(String phone) {
    return 'Call $phone and read them your code. Delivery and any fee are arranged with the store.';
  }

  @override
  String onItsWaySince(String time) {
    return 'With the store\'s driver since $time';
  }

  @override
  String get factDeliveredAt => 'Delivered';

  @override
  String get cancelledNotDeliveredTitle => 'The store cancelled this delivery';

  @override
  String get cancelledNotDelivered =>
      'The store says the delivery didn\'t happen. This doesn\'t count against you.';

  @override
  String get cancelledStoreClosedTitle => 'The store closed early';

  @override
  String get cancelledStoreClosed =>
      'The store had to close, so your booking was cancelled. This doesn\'t count against you.';

  @override
  String get reportProblem => 'Report a problem';

  @override
  String get reportTitle => 'What went wrong?';

  @override
  String get reportSubtitle =>
      'Your report reaches our team with this booking.';

  @override
  String get reportReasonStoreClosed => 'The store was closed';

  @override
  String get reportReasonNotGiven => 'The store didn\'t give me my booking';

  @override
  String get reportReasonPriceDifferent => 'I was asked to pay more';

  @override
  String get reportReasonQuality => 'Something was wrong with it';

  @override
  String get reportReasonOther => 'Something else';

  @override
  String get reportNoteLabel => 'What happened?';

  @override
  String get reportNoteHint => 'For example: I came at 8:30 and it was shut';

  @override
  String get reportSend => 'Send report';

  @override
  String get reportSent => 'We got your report and will look into it.';

  @override
  String get reportSentTitle => 'You reported a problem';

  @override
  String get reportOpen => 'We\'re looking into it.';

  @override
  String get reportResolved => 'We looked into it.';

  @override
  String get reportResolvedStrikeRemoved =>
      'We looked into it: this booking no longer counts against you.';

  @override
  String get reportAlready => 'You already reported this booking.';

  @override
  String get reportTooLate => 'This booking ended too long ago to report.';
}
