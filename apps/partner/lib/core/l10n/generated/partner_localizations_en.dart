// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'partner_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class PartnerLocalizationsEn extends PartnerLocalizations {
  PartnerLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pickupInstructionsLabel => 'Pickup instructions';

  @override
  String get pickupInstructionsHint =>
      'e.g. Show your code at the cashier by the door; bring a bag.';

  @override
  String get pickupInstructionsHelper =>
      'Customers see this on every offer: where to go in the shop and what to bring.';

  @override
  String get ratingLabel => 'Rating';

  @override
  String ratingSummary(double average, int count) {
    final intl.NumberFormat averageNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String averageString = averageNumberFormat.format(average);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ratings',
      one: '1 rating',
    );
    return '★ $averageString · $_temp0';
  }

  @override
  String get noRatingsYet => 'No ratings yet';

  @override
  String get appTitle => 'Kaziony for Stores';

  @override
  String get loginTitle => 'Welcome to your store';

  @override
  String get loginSubtitle =>
      'Log in with the phone number and password our team gave you.';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Log in';

  @override
  String get loginJoinHint => 'Store not on Kaziony yet?';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get contactUs => 'Contact us';

  @override
  String get termsAgreement => 'By signing in, you agree to the';

  @override
  String get contactMessage =>
      'Forgot your password, want to add your store or need a hand? Our team is here to help.';

  @override
  String get callUs => 'Call';

  @override
  String get whatsappUs => 'WhatsApp';

  @override
  String get supportHours => 'When we answer';

  @override
  String get linkNotOpened => 'Couldn\'t open it on this phone.';

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
  String get logoutTitle => 'Log out?';

  @override
  String get logoutMessage =>
      'You\'ll need your phone number and password to sign in again.';

  @override
  String get homeTitle => 'Home';

  @override
  String get profileTitle => 'Profile';

  @override
  String get chooseStoreTitle => 'Choose a store';

  @override
  String get chooseStoreSubtitle =>
      'You work at more than one store. You can switch later from your profile.';

  @override
  String get ownerRole => 'Owner';

  @override
  String get staffRole => 'Staff';

  @override
  String get switchStore => 'Switch store';

  @override
  String get noStoreTitle => 'No store yet';

  @override
  String get noStoreMessage =>
      'This account isn\'t linked to a store. Contact our team to set it up.';

  @override
  String get storeInfoTitle => 'Store info';

  @override
  String get storeLogo => 'Logo';

  @override
  String get storeCover => 'Cover photo';

  @override
  String get addLogo => 'Add your logo';

  @override
  String get addCover => 'Add a cover photo';

  @override
  String get coverHint => 'Your shop front or what you sell';

  @override
  String get storeImagesHint =>
      'Customers see your logo by your name, and the cover across the top of your page.';

  @override
  String get storeInfoHint => 'Customers see this on your store\'s page.';

  @override
  String get liveStoreNeedsPickupInstructions =>
      'Customers see your store, so the pickup instructions can\'t be empty.';

  @override
  String get storeNameLabel => 'Store name';

  @override
  String get storeNameHint =>
      'Our team sets your store\'s name and category. Contact us to change them.';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get discardChangesTitle => 'Discard your changes?';

  @override
  String get discardChangesMessage =>
      'Your changes haven\'t been saved. Leave without saving?';

  @override
  String get discardChanges => 'Discard';

  @override
  String get teamTitle => 'Team';

  @override
  String get locationTitle => 'Location and hours';

  @override
  String get cityLabel => 'City';

  @override
  String get areaLabel => 'Area';

  @override
  String get addressLabel => 'Address';

  @override
  String get openInMaps => 'Open in Maps';

  @override
  String get openingHoursTitle => 'Opening hours';

  @override
  String get openingHoursHint => 'Tap a day to change its hours.';

  @override
  String get liveStoreNeedsOpeningHours =>
      'Customers see your store, so it needs opening hours on at least one day.';

  @override
  String get locationTeamHint =>
      'Our team changes the store\'s name and location, and adds new branches.';

  @override
  String get requestChange => 'Request a change';

  @override
  String requestPlaceMessage(String store) {
    return 'Hello, I\'d like to add a new branch or change the details of the store: $store';
  }

  @override
  String requestStaffMessage(String store) {
    return 'Hello, I\'d like to add or remove staff at the store: $store';
  }

  @override
  String get openDay => 'Open';

  @override
  String get closedAllDay => 'Closed';

  @override
  String shiftHours(String opens, String closes) {
    return '$opens – $closes';
  }

  @override
  String get opensAt => 'Opens';

  @override
  String get closesAt => 'Closes';

  @override
  String get afterBreak => 'After a break';

  @override
  String get addShift => 'Add hours after a break';

  @override
  String get removeShift => 'Remove these hours';

  @override
  String get sameEveryDay => 'Same hours every day';

  @override
  String get done => 'Done';

  @override
  String todayAt(String store) {
    return 'Today at $store';
  }

  @override
  String get yourStoreSection => 'Your store';

  @override
  String get teamHint => 'To add or remove someone, contact our team.';

  @override
  String get accountSection => 'Your account';

  @override
  String get changePasswordAction => 'Change password';

  @override
  String get appSection => 'App';

  @override
  String get helpSection => 'Help';

  @override
  String get aboutTitle => 'About the app';

  @override
  String get aboutText =>
      'Post limited offers from your products in seconds, and hand them over at the counter with a pickup code.';

  @override
  String get termsTitle => 'Terms and conditions';

  @override
  String get termsSoonTitle => 'Coming soon';

  @override
  String get termsSoonMessage =>
      'The terms and conditions will be here before the app opens to everyone.';

  @override
  String get versionLabel => 'Version';

  @override
  String get categoryLabel => 'Category';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get emailLabel => 'Email';

  @override
  String get facebookLabel => 'Facebook';

  @override
  String get instagramLabel => 'Instagram';

  @override
  String get notSet => 'Not set';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved.';

  @override
  String get inactive => 'Inactive';

  @override
  String get cityTripoli => 'Tripoli';

  @override
  String get oldPasswordLabel => 'Current password';

  @override
  String get wrongOldPassword => 'The current password is wrong.';

  @override
  String get productsTitle => 'Products';

  @override
  String get addProduct => 'Add product';

  @override
  String get newProductTitle => 'New product';

  @override
  String get editProductTitle => 'Edit product';

  @override
  String get searchProducts => 'Search products';

  @override
  String get currentProducts => 'Current';

  @override
  String get archivedProducts => 'Archived';

  @override
  String get productAddPhoto => 'Add a photo';

  @override
  String get noProductsTitle => 'No products yet';

  @override
  String get noProductsMessage =>
      'Add what you sell, then post offers from it in seconds.';

  @override
  String get noProductsMatch => 'No products match your search.';

  @override
  String get noArchivedProducts => 'No archived products.';

  @override
  String get productTitleLabel => 'Name';

  @override
  String get regularPriceLabel => 'Regular price';

  @override
  String get regularPriceHelper =>
      'Its everyday price in the store. The offer\'s is lower.';

  @override
  String get archiveProduct => 'Archive';

  @override
  String get productPhotoTipTitle => 'Add a photo';

  @override
  String get productPhotoTipMessage =>
      'Customers see it first on every offer from this product.';

  @override
  String get noDescription => 'No description yet.';

  @override
  String get add => 'Add';

  @override
  String get productDetailsTitle => 'Details';

  @override
  String get productAddedOn => 'Added';

  @override
  String get productEditedOn => 'Last edited';

  @override
  String get archiveProductHint =>
      'Hidden from your products. Its past offers stay.';

  @override
  String get productBasicsSection => 'What you sell';

  @override
  String get productBasicsNote =>
      'Customers see its name and description on every offer.';

  @override
  String get priceSection => 'Price';

  @override
  String get productTitleHint => 'e.g. Butter croissant';

  @override
  String get descriptionHint => 'What\'s in it, its size, how it\'s made';

  @override
  String get archivedStatus => 'Archived';

  @override
  String get restoreProduct => 'Restore';

  @override
  String get productArchived => 'Archived.';

  @override
  String get productRestored => 'Restored.';

  @override
  String get productSavedPhotoFailed =>
      'Saved. The photo didn\'t upload: tap it to try again.';

  @override
  String get offersTitle => 'Offers';

  @override
  String get postOffer => 'Post an offer';

  @override
  String get noOffersTitle => 'No offers yet';

  @override
  String get noOffersMessage =>
      'Post one from a product: customers nearby see it right away.';

  @override
  String get noOffersHere => 'No offers here.';

  @override
  String get activeOffers => 'Active';

  @override
  String get endedOffers => 'Ended';

  @override
  String get liveNowSection => 'Live now';

  @override
  String get comingUpSection => 'Coming up';

  @override
  String get pausedSection => 'Paused';

  @override
  String figureLeftOf(int total) {
    return 'left of $total';
  }

  @override
  String get figureSoldOut => 'Sold out';

  @override
  String figureAllOf(int total) {
    return 'all $total';
  }

  @override
  String get offerLive => 'Live';

  @override
  String get offerScheduled => 'Scheduled';

  @override
  String get offerSoldOut => 'Sold out';

  @override
  String get offerPaused => 'Paused';

  @override
  String get offerEnded => 'Ended';

  @override
  String get offerRemoved => 'Removed by our team';

  @override
  String get noLimit => 'No limit';

  @override
  String until(String date) {
    return 'Until $date';
  }

  @override
  String get chooseProductTitle => 'Choose a product';

  @override
  String get noProductsForOffer =>
      'Post something new, and it\'s saved here for next time.';

  @override
  String get newOfferTitle => 'New offer';

  @override
  String get startOfferTitle => 'What\'s the offer on?';

  @override
  String get fromMyProducts => 'From my products';

  @override
  String get fromMyProductsHint => 'One you\'ve saved before';

  @override
  String get somethingNew => 'Something new';

  @override
  String get somethingNewHint => 'Add its photo and price, and post it now';

  @override
  String get offerPhotoHint =>
      'Optional, but offers with a photo get reserved more';

  @override
  String get quickProductNote => 'Saved to your products';

  @override
  String get offerPostedPhotoFailed =>
      'Offer posted. The photo didn\'t upload: add it from the product\'s page.';

  @override
  String regularPriceIs(String price) {
    return 'Regular price $price';
  }

  @override
  String get offerPriceLabel => 'Offer price';

  @override
  String offerPriceTooHigh(String price) {
    return 'Must be lower than the regular price ($price)';
  }

  @override
  String get offerTypeLabel => 'Pieces';

  @override
  String get limitedType => 'A set number';

  @override
  String get unlimitedType => 'No limit';

  @override
  String get quantityLabel => 'How many pieces';

  @override
  String get perCustomerLabel => 'Per customer';

  @override
  String get endsLabel => 'Ends';

  @override
  String get endsTonight => 'Tonight';

  @override
  String get endsTomorrow => 'Tomorrow night';

  @override
  String get endsIn3Days => 'In 3 days';

  @override
  String get endsInAWeek => 'In a week';

  @override
  String get endsInPast => 'Choose a time that\'s still to come.';

  @override
  String get endsTooLate => 'Offers can last at most 30 days.';

  @override
  String get offerPosted => 'Offer posted.';

  @override
  String holdValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get startsLabel => 'Starts';

  @override
  String get pauseOffer => 'Pause';

  @override
  String get resumeOffer => 'Resume';

  @override
  String get endOffer => 'End the offer';

  @override
  String get endOfferTitle => 'End this offer?';

  @override
  String get endOfferMessage =>
      'Customers can\'t claim it anymore. Reservations already made can still be picked up.';

  @override
  String get offerPausedDone => 'Paused: customers don\'t see it now.';

  @override
  String get offerResumed => 'Customers see it again.';

  @override
  String get offerEndedDone => 'Offer ended.';

  @override
  String get repostOffer => 'Post it again';

  @override
  String get editOfferTitle => 'Edit the offer';

  @override
  String get offerTitleLabel => 'Title';

  @override
  String get holdTitle => 'Held for';

  @override
  String get scanTitle => 'Scan';

  @override
  String get scanHint => 'Point the camera at the customer\'s code';

  @override
  String get typeCode => 'Type the code';

  @override
  String get codeLabel => 'Code';

  @override
  String get tapToCopy => 'Tap to copy';

  @override
  String get codeCopied => 'Code copied';

  @override
  String get codeHelper =>
      'The 8 letters and numbers under the customer\'s QR code.';

  @override
  String get checkCode => 'Check the code';

  @override
  String get notAClaimCode => 'This QR code isn\'t a reservation.';

  @override
  String get cameraOffScanMessage =>
      'Allow the camera for this app in Settings to scan codes, or type the code.';

  @override
  String get cameraFailedTitle => 'The camera didn\'t open';

  @override
  String get cameraFailedMessage => 'Type the customer\'s code instead.';

  @override
  String get pickupsTitle => 'On their way';

  @override
  String get noPickupsTitle => 'No one is on their way';

  @override
  String get noPickupsMessage =>
      'Reservations show here until they\'re picked up.';

  @override
  String get someCustomer => 'A customer';

  @override
  String get claimTitle => 'Pickup';

  @override
  String get toCollect => 'To collect';

  @override
  String get customerLabel => 'Customer';

  @override
  String get heldUntil => 'Held until';

  @override
  String get pickedUpAtLabel => 'Picked up';

  @override
  String get confirmPickup => 'Confirm pickup';

  @override
  String problemRedeemedAt(String time) {
    return 'Already picked up: $time.';
  }

  @override
  String get problemRedeemed => 'Already picked up.';

  @override
  String get problemCancelled => 'The customer cancelled this reservation.';

  @override
  String get problemExpired => 'This reservation has expired.';

  @override
  String get problemOther => 'This code can\'t be picked up.';

  @override
  String get claimNotFound => 'No reservation with this code at your store.';

  @override
  String get pickedUpTitle => 'Picked up';

  @override
  String get nextCustomer => 'Next customer';

  @override
  String get refresh => 'Refresh';

  @override
  String get todayTitle => 'Today';

  @override
  String get statPickedUp => 'Picked up';

  @override
  String get statNotPickedUp => 'Not picked up';

  @override
  String get statLiveOffers => 'Live offers';

  @override
  String soonestIn(String time) {
    return 'Soonest due in $time';
  }

  @override
  String ofClaimsToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'of $count reserved today',
      one: 'of 1 reserved today',
    );
    return '$_temp0';
  }

  @override
  String almostGone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count almost gone',
      one: 'One almost gone',
    );
    return '$_temp0';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String hoursShort(int hours) {
    return '$hours h';
  }

  @override
  String get seeAll => 'See all';

  @override
  String get yourLiveOffers => 'Your live offers';

  @override
  String get liveOffersTitle => 'Live offers';

  @override
  String get nobodyOnTheWay => 'No one is on their way right now.';

  @override
  String get noLiveOffers => 'No live offers right now.';

  @override
  String get quietDayTitle => 'A quiet day so far';

  @override
  String get quietDayOwnerMessage =>
      'Post an offer, and customers who reserve it will show up here on their way.';

  @override
  String get quietDayStaffMessage =>
      'When your store posts an offer, customers who reserve it will show up here.';

  @override
  String get storeNotLiveTitle => 'Customers can\'t see your store yet';

  @override
  String get storeNotLiveOwnerMessage =>
      'Add these, then our team will turn it on for customers.';

  @override
  String get storeNotLiveStaffMessage =>
      'The store\'s owner needs to add these first.';

  @override
  String get storeReadyTitle => 'Your store is ready';

  @override
  String get storeReadyMessage =>
      'Our team will turn it on for customers soon.';

  @override
  String get messageUsOnWhatsApp => 'Message us on WhatsApp';

  @override
  String turnOnStoreMessage(String store) {
    return 'Hello, my store is ready. Please turn it on for customers: $store';
  }

  @override
  String get storeOffTitle => 'Your store is off for customers';

  @override
  String get storeOffMessage =>
      'Customers can\'t see it or its offers right now. Bookings already made can still be picked up.';

  @override
  String askWhyStoreOffMessage(String store) {
    return 'Hello, my store is off for customers. Could you tell me why? $store';
  }

  @override
  String get storeNotLiveCantPost =>
      'Customers can\'t see your store yet, so it can\'t post offers. Home shows what\'s left.';

  @override
  String get soonestFirst => 'Soonest to end first';

  @override
  String get pickupsEndNote =>
      'Reservations stay here until they\'re picked up or their time runs out.';

  @override
  String get collectFromCustomer => 'Collect from the customer';

  @override
  String piecesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces',
      one: '1 piece',
    );
    return '$_temp0';
  }

  @override
  String get claimReserved => 'Reserved';

  @override
  String get claimRedeemed => 'Picked up';

  @override
  String get claimExpired => 'Expired';

  @override
  String get claimCancelled => 'Cancelled';

  @override
  String heldUntilLeft(String time, String left) {
    return '$time ($left left)';
  }

  @override
  String get problemRedeemedHint =>
      'Don\'t hand it over again. If the customer says they didn\'t get it, check with your colleagues.';

  @override
  String get problemCancelledHint =>
      'Don\'t hand it over. The customer can reserve again if the offer is still on.';

  @override
  String get problemExpiredHint =>
      'Don\'t hand it over. The customer can reserve again if the offer is still on.';

  @override
  String get checkCustomerTitle => 'Is it the right customer?';

  @override
  String checkCustomerMessage(String item, String name, String amount) {
    return 'Make sure you handed $item to $name and collected $amount.';
  }

  @override
  String get checkCustomerConfirm => 'Yes, picked up';

  @override
  String perPiece(String price) {
    return '$price each';
  }

  @override
  String get payInCash => 'Paid in cash';

  @override
  String get figurePickedUp => 'Picked up';

  @override
  String get figureOnTheWay => 'On the way';

  @override
  String get figureLeft => 'Left';

  @override
  String get figureReady => 'Ready';

  @override
  String offerPriceAndWhen(String price, String when) {
    return '$price, $when';
  }

  @override
  String endsAt(String time) {
    return 'Ends $time';
  }

  @override
  String startsAt(String time) {
    return 'Starts $time';
  }

  @override
  String endedAt(String time) {
    return 'Ended $time';
  }

  @override
  String get dayToday => 'Today';

  @override
  String get offerPiecesTitle => 'Pieces';

  @override
  String get offerDetailsTitle => 'Details';

  @override
  String get seenLabel => 'Seen';

  @override
  String leftOfTotal(int left, int total) {
    return '$left of $total';
  }

  @override
  String dayAndTime(String day, String time) {
    return '$day $time';
  }

  @override
  String notPickedUpOrCancelled(int expired, int cancelled) {
    return '$expired not picked up, $cancelled cancelled';
  }

  @override
  String get moreActions => 'More';

  @override
  String get endOfferHint => 'Customers stop seeing it, for good';

  @override
  String discountBadge(int percent) {
    return '-$percent%';
  }

  @override
  String get unlimitedHint => 'Stays up until it ends or you pause it.';

  @override
  String get listSeparator => ', ';

  @override
  String get reservationsTitle => 'Reservations';

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
  String get noLimitPerCustomer => 'No limit per customer';

  @override
  String piecesPerCustomer(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces per customer',
      one: '1 piece per customer',
    );
    return '$_temp0';
  }

  @override
  String get atMost => 'At most';

  @override
  String get anyCustomerAll => 'One customer can take every piece.';

  @override
  String postSummary(String pieces, String when) {
    return '$pieces · ends $when';
  }

  @override
  String get claimOutForDelivery => 'Out for delivery';

  @override
  String get sendForDelivery => 'Send for delivery';

  @override
  String get markDelivered => 'Delivered';

  @override
  String get notDelivered => 'Didn\'t happen';

  @override
  String get sentForDeliveryTitle => 'With your driver';

  @override
  String get driverCollects => 'For the driver to collect';

  @override
  String get deliveredTitle => 'Delivered';

  @override
  String get paidOnDelivery => 'Paid on delivery';

  @override
  String checkSendMessage(String item, String name, String amount) {
    return 'Your driver takes $item to $name, and collects $amount.';
  }

  @override
  String checkDeliveredMessage(String item, String name, String amount) {
    return 'Make sure your driver handed $item to $name and collected $amount.';
  }

  @override
  String get notDeliveredTitle => 'The delivery didn\'t happen?';

  @override
  String notDeliveredMessage(String name) {
    return 'The booking is cancelled and its pieces go back on sale. $name is told, and it doesn\'t count against them.';
  }

  @override
  String get cancelBooking => 'Cancel the booking';

  @override
  String get keepIt => 'Keep it';

  @override
  String get notDeliveredDone =>
      'Booking cancelled. Its pieces are back on sale.';

  @override
  String outForDeliverySince(String time) {
    return 'With your driver since $time';
  }

  @override
  String get outForDeliveryHint =>
      'Close it once it\'s delivered, or if it didn\'t happen. After a day, it\'s taken as delivered.';

  @override
  String get deliveredAtLabel => 'Delivered';

  @override
  String get sentForDeliveryAtLabel => 'With the driver since';

  @override
  String get deliveriesTitle => 'Deliveries';

  @override
  String get noDeliveriesTitle => 'No deliveries out';

  @override
  String get noDeliveriesMessage =>
      'Bookings your driver takes show here until you close them.';

  @override
  String get longestOutFirst => 'Longest out first';

  @override
  String get deliveriesEndNote =>
      'A delivery left open a day is taken as delivered.';

  @override
  String deliveriesOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deliveries to close',
      one: '1 delivery to close',
    );
    return '$_temp0';
  }

  @override
  String get deliveriesOutHint =>
      'Say if each was delivered. After a day, they\'re taken as delivered.';

  @override
  String get deliveryLabel => 'Delivery';

  @override
  String get pickupOnly => 'Pickup only';

  @override
  String get weDeliver => 'We deliver too';

  @override
  String get weDeliverHint =>
      'Customers with a booking see a number to call to have it brought. Delivery and any fee are between you and them. When your driver takes one, look its code up and tap Send for delivery.';

  @override
  String get deliveryPhoneLabel => 'Number for delivery';

  @override
  String get deliveryPhoneHelper =>
      'Leave it empty and customers call your store\'s number.';
}
