// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'partner_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class PartnerLocalizationsEn extends PartnerLocalizations {
  PartnerLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Offers for Stores';

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
  String get loginJoinHint =>
      'Store not on Kaziony yet? Talk to us and we\'ll add it.';

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
  String get storeInfoHint => 'Customers see this on your store\'s page.';

  @override
  String get branchesTitle => 'Branches';

  @override
  String get teamTitle => 'Team';

  @override
  String get teamHint => 'To add or remove someone, contact our team.';

  @override
  String get accountSection => 'Account';

  @override
  String get changePasswordAction => 'Change password';

  @override
  String get appSection => 'App';

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
  String get allBranches => 'All branches';

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
  String get regularPriceHelper => 'The usual price, before any offer.';

  @override
  String get archiveProduct => 'Archive';

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
  String get allOffers => 'All';

  @override
  String get activeOffers => 'Active';

  @override
  String get pausedOffers => 'Paused';

  @override
  String get endedOffers => 'Ended';

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
  String piecesLeft(int left, int total) {
    return '$left of $total left';
  }

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
      'Offers are posted from your products. Add one first.';

  @override
  String get newOfferTitle => 'New offer';

  @override
  String regularPriceIs(String price) {
    return 'Regular price $price';
  }

  @override
  String get offerPriceLabel => 'Offer price';

  @override
  String discountHelper(int percent) {
    return '$percent% off the regular price';
  }

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
  String get holdLabel => 'Held for (minutes)';

  @override
  String get holdHelper =>
      'How long a reservation waits for the customer to come.';

  @override
  String get perCustomerLabel => 'Per customer';

  @override
  String get perCustomerHelper => 'How many times one customer can claim it.';

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
  String get chooseABranch => 'Choose at least one branch.';

  @override
  String get offerPosted => 'Offer posted.';

  @override
  String get claimsSection => 'Claims';

  @override
  String get claimsReserved => 'Reserved';

  @override
  String get claimsRedeemed => 'Picked up';

  @override
  String get claimsExpired => 'Not picked up';

  @override
  String get claimsCancelled => 'Cancelled';

  @override
  String holdValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get startsLabel => 'Starts';

  @override
  String branchCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count branches',
      one: '1 branch',
    );
    return '$_temp0';
  }

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
  String get codeHelper =>
      'The 8 letters and numbers under the customer\'s QR code.';

  @override
  String get codeInvalid => 'A code is 8 letters and numbers, like ABCD2345.';

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
  String get problemOtherBranch => 'This offer isn\'t for your branch.';

  @override
  String get problemOther => 'This code can\'t be picked up.';

  @override
  String get claimNotFound => 'No reservation with this code at your store.';

  @override
  String get pickedUpTitle => 'Picked up';

  @override
  String get nextCustomer => 'Next customer';

  @override
  String get counterBranch => 'Your branch';

  @override
  String get chooseCounterBranch => 'Which branch are you at?';

  @override
  String get chooseValue => 'Choose';

  @override
  String get redeemWrongBranch =>
      'This offer isn\'t valid at the branch picked on this phone.';

  @override
  String get refresh => 'Refresh';

  @override
  String get piecesLabel => 'Pieces';

  @override
  String get todayTitle => 'Today';

  @override
  String get todayAtBranch => 'Today at your branch';

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
  String get notPickedUpHint => 'Their time ran out';

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
  String get seeAllOffers => 'All offers';

  @override
  String get yourLiveOffers => 'Your live offers';

  @override
  String get liveOffersTitle => 'Live offers';

  @override
  String get nobodyOnTheWay => 'No one is on their way right now.';

  @override
  String get noLiveOffers => 'No live offers right now.';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String pickupsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pickups',
      one: '1 pickup',
      zero: 'No pickups yet',
    );
    return '$_temp0';
  }

  @override
  String pickupRate(int percent) {
    return '$percent% picked up';
  }

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
  String get branchLabel => 'Branch';

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
  String get problemOtherBranchHint =>
      'The customer can pick it up at a branch that has this offer.';

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
  String get figureViews => 'Views';

  @override
  String get figureReserved => 'Reservations';

  @override
  String get figurePickedUp => 'Picked up';

  @override
  String endsAt(String time) {
    return 'Ends $time';
  }

  @override
  String get dayToday => 'Today';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String hoursMinutesShort(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String discountOff(int percent) {
    return '$percent% off';
  }
}
