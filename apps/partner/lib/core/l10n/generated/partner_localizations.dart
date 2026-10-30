import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'partner_localizations_ar.dart';
import 'partner_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of PartnerLocalizations
/// returned by `PartnerLocalizations.of(context)`.
///
/// Applications need to include `PartnerLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/partner_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: PartnerLocalizations.localizationsDelegates,
///   supportedLocales: PartnerLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the PartnerLocalizations.supportedLocales
/// property.
abstract class PartnerLocalizations {
  PartnerLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static PartnerLocalizations of(BuildContext context) {
    return Localizations.of<PartnerLocalizations>(
      context,
      PartnerLocalizations,
    )!;
  }

  static const LocalizationsDelegate<PartnerLocalizations> delegate =
      _PartnerLocalizationsDelegate();

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
  /// **'Offers for Stores'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to your store'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in with the phone number and password our team gave you.'**
  String get loginSubtitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @loginJoinHint.
  ///
  /// In en, this message translates to:
  /// **'Store not on Kaziony yet? Talk to us and we\'ll add it.'**
  String get loginJoinHint;

  /// No description provided for @wrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong phone number or password.'**
  String get wrongCredentials;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account is disabled. Contact us.'**
  String get accountDisabled;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session ended. Please log in again.'**
  String get sessionExpired;

  /// No description provided for @notStoreAccount.
  ///
  /// In en, this message translates to:
  /// **'This app is for store accounts only.'**
  String get notStoreAccount;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re using a temporary password. Choose your own to continue.'**
  String get changePasswordSubtitle;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Temporary password'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Repeat the new password'**
  String get confirmPasswordLabel;

  /// No description provided for @savePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get savePasswordButton;

  /// No description provided for @wrongCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'The temporary password is wrong.'**
  String get wrongCurrentPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed.'**
  String get passwordChanged;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @chooseStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a store'**
  String get chooseStoreTitle;

  /// No description provided for @chooseStoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You work at more than one store. You can switch later from your profile.'**
  String get chooseStoreSubtitle;

  /// No description provided for @ownerRole.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get ownerRole;

  /// No description provided for @staffRole.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffRole;

  /// No description provided for @switchStore.
  ///
  /// In en, this message translates to:
  /// **'Switch store'**
  String get switchStore;

  /// No description provided for @noStoreTitle.
  ///
  /// In en, this message translates to:
  /// **'No store yet'**
  String get noStoreTitle;

  /// No description provided for @noStoreMessage.
  ///
  /// In en, this message translates to:
  /// **'This account isn\'t linked to a store. Contact our team to set it up.'**
  String get noStoreMessage;

  /// No description provided for @storeSection.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get storeSection;

  /// No description provided for @storeInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Store info'**
  String get storeInfoTitle;

  /// No description provided for @storeInfoHint.
  ///
  /// In en, this message translates to:
  /// **'Customers see this on your store\'s page.'**
  String get storeInfoHint;

  /// No description provided for @branchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branchesTitle;

  /// No description provided for @teamTitle.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamTitle;

  /// No description provided for @teamHint.
  ///
  /// In en, this message translates to:
  /// **'To add or remove someone, contact our team.'**
  String get teamHint;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @changePasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordAction;

  /// No description provided for @appSection.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get appSection;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @facebookLabel.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebookLabel;

  /// No description provided for @instagramLabel.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagramLabel;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get saved;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @allBranches.
  ///
  /// In en, this message translates to:
  /// **'All branches'**
  String get allBranches;

  /// No description provided for @cityTripoli.
  ///
  /// In en, this message translates to:
  /// **'Tripoli'**
  String get cityTripoli;

  /// No description provided for @oldPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get oldPasswordLabel;

  /// No description provided for @wrongOldPassword.
  ///
  /// In en, this message translates to:
  /// **'The current password is wrong.'**
  String get wrongOldPassword;

  /// No description provided for @productsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTitle;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProduct;

  /// No description provided for @newProductTitle.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get newProductTitle;

  /// No description provided for @editProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProductTitle;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchProducts;

  /// No description provided for @currentProducts.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentProducts;

  /// No description provided for @archivedProducts.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archivedProducts;

  /// No description provided for @noProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProductsTitle;

  /// No description provided for @noProductsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add what you sell, then post offers from it in seconds.'**
  String get noProductsMessage;

  /// No description provided for @noProductsMatch.
  ///
  /// In en, this message translates to:
  /// **'No products match your search.'**
  String get noProductsMatch;

  /// No description provided for @noArchivedProducts.
  ///
  /// In en, this message translates to:
  /// **'No archived products.'**
  String get noArchivedProducts;

  /// No description provided for @productTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get productTitleLabel;

  /// No description provided for @regularPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Regular price'**
  String get regularPriceLabel;

  /// No description provided for @regularPriceHelper.
  ///
  /// In en, this message translates to:
  /// **'The usual price, before any offer.'**
  String get regularPriceHelper;

  /// No description provided for @archiveProduct.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveProduct;

  /// No description provided for @restoreProduct.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreProduct;

  /// No description provided for @productArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived.'**
  String get productArchived;

  /// No description provided for @productRestored.
  ///
  /// In en, this message translates to:
  /// **'Restored.'**
  String get productRestored;

  /// No description provided for @productAddedAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Saved. Now add its photo.'**
  String get productAddedAddPhoto;

  /// No description provided for @offersTitle.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offersTitle;

  /// No description provided for @postOffer.
  ///
  /// In en, this message translates to:
  /// **'Post an offer'**
  String get postOffer;

  /// No description provided for @noOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'No offers yet'**
  String get noOffersTitle;

  /// No description provided for @noOffersMessage.
  ///
  /// In en, this message translates to:
  /// **'Post one from a product: customers nearby see it right away.'**
  String get noOffersMessage;

  /// No description provided for @noOffersHere.
  ///
  /// In en, this message translates to:
  /// **'No offers here.'**
  String get noOffersHere;

  /// No description provided for @allOffers.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allOffers;

  /// No description provided for @activeOffers.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeOffers;

  /// No description provided for @pausedOffers.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get pausedOffers;

  /// No description provided for @endedOffers.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get endedOffers;

  /// No description provided for @offerLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get offerLive;

  /// No description provided for @offerScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get offerScheduled;

  /// No description provided for @offerSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold out'**
  String get offerSoldOut;

  /// No description provided for @offerPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get offerPaused;

  /// No description provided for @offerEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get offerEnded;

  /// No description provided for @offerRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed by our team'**
  String get offerRemoved;

  /// No description provided for @piecesLeft.
  ///
  /// In en, this message translates to:
  /// **'{left} of {total} left'**
  String piecesLeft(int left, int total);

  /// No description provided for @noLimit.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get noLimit;

  /// No description provided for @until.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String until(String date);

  /// No description provided for @chooseProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a product'**
  String get chooseProductTitle;

  /// No description provided for @noProductsForOffer.
  ///
  /// In en, this message translates to:
  /// **'Offers are posted from your products. Add one first.'**
  String get noProductsForOffer;

  /// No description provided for @newOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'New offer'**
  String get newOfferTitle;

  /// No description provided for @regularPriceIs.
  ///
  /// In en, this message translates to:
  /// **'Regular price {price}'**
  String regularPriceIs(String price);

  /// No description provided for @offerPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Offer price'**
  String get offerPriceLabel;

  /// No description provided for @discountHelper.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off the regular price'**
  String discountHelper(int percent);

  /// No description provided for @offerPriceTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Must be lower than the regular price ({price})'**
  String offerPriceTooHigh(String price);

  /// No description provided for @offerTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pieces'**
  String get offerTypeLabel;

  /// No description provided for @limitedType.
  ///
  /// In en, this message translates to:
  /// **'A set number'**
  String get limitedType;

  /// No description provided for @unlimitedType.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get unlimitedType;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'How many pieces'**
  String get quantityLabel;

  /// No description provided for @holdLabel.
  ///
  /// In en, this message translates to:
  /// **'Held for (minutes)'**
  String get holdLabel;

  /// No description provided for @holdHelper.
  ///
  /// In en, this message translates to:
  /// **'How long a reservation waits for the customer to come.'**
  String get holdHelper;

  /// No description provided for @perCustomerLabel.
  ///
  /// In en, this message translates to:
  /// **'Per customer'**
  String get perCustomerLabel;

  /// No description provided for @perCustomerHelper.
  ///
  /// In en, this message translates to:
  /// **'How many times one customer can claim it.'**
  String get perCustomerHelper;

  /// No description provided for @endsLabel.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get endsLabel;

  /// No description provided for @endsTonight.
  ///
  /// In en, this message translates to:
  /// **'Tonight'**
  String get endsTonight;

  /// No description provided for @endsTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow night'**
  String get endsTomorrow;

  /// No description provided for @endsIn3Days.
  ///
  /// In en, this message translates to:
  /// **'In 3 days'**
  String get endsIn3Days;

  /// No description provided for @endsInAWeek.
  ///
  /// In en, this message translates to:
  /// **'In a week'**
  String get endsInAWeek;

  /// No description provided for @endsInPast.
  ///
  /// In en, this message translates to:
  /// **'Choose a time that\'s still to come.'**
  String get endsInPast;

  /// No description provided for @endsTooLate.
  ///
  /// In en, this message translates to:
  /// **'Offers can last at most 30 days.'**
  String get endsTooLate;

  /// No description provided for @chooseABranch.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one branch.'**
  String get chooseABranch;

  /// No description provided for @offerPosted.
  ///
  /// In en, this message translates to:
  /// **'Offer posted.'**
  String get offerPosted;

  /// No description provided for @claimsSection.
  ///
  /// In en, this message translates to:
  /// **'Claims'**
  String get claimsSection;

  /// No description provided for @claimsReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get claimsReserved;

  /// No description provided for @claimsRedeemed.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get claimsRedeemed;

  /// No description provided for @claimsExpired.
  ///
  /// In en, this message translates to:
  /// **'Not picked up'**
  String get claimsExpired;

  /// No description provided for @claimsCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get claimsCancelled;

  /// No description provided for @holdValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String holdValue(int minutes);

  /// No description provided for @startsLabel.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get startsLabel;

  /// No description provided for @branchCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 branch} other{{count} branches}}'**
  String branchCount(int count);

  /// No description provided for @pauseOffer.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseOffer;

  /// No description provided for @resumeOffer.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeOffer;

  /// No description provided for @endOffer.
  ///
  /// In en, this message translates to:
  /// **'End the offer'**
  String get endOffer;

  /// No description provided for @endOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'End this offer?'**
  String get endOfferTitle;

  /// No description provided for @endOfferMessage.
  ///
  /// In en, this message translates to:
  /// **'Customers can\'t claim it anymore. Reservations already made can still be picked up.'**
  String get endOfferMessage;

  /// No description provided for @offerPausedDone.
  ///
  /// In en, this message translates to:
  /// **'Paused: customers don\'t see it now.'**
  String get offerPausedDone;

  /// No description provided for @offerResumed.
  ///
  /// In en, this message translates to:
  /// **'Customers see it again.'**
  String get offerResumed;

  /// No description provided for @offerEndedDone.
  ///
  /// In en, this message translates to:
  /// **'Offer ended.'**
  String get offerEndedDone;

  /// No description provided for @repostOffer.
  ///
  /// In en, this message translates to:
  /// **'Post it again'**
  String get repostOffer;

  /// No description provided for @editOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit the offer'**
  String get editOfferTitle;

  /// No description provided for @offerTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get offerTitleLabel;

  /// No description provided for @holdTitle.
  ///
  /// In en, this message translates to:
  /// **'Held for'**
  String get holdTitle;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanTitle;

  /// No description provided for @scanHint.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the customer\'s code'**
  String get scanHint;

  /// No description provided for @typeCode.
  ///
  /// In en, this message translates to:
  /// **'Type the code'**
  String get typeCode;

  /// No description provided for @codeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get codeLabel;

  /// No description provided for @codeHelper.
  ///
  /// In en, this message translates to:
  /// **'The 8 letters and numbers under the customer\'s QR code.'**
  String get codeHelper;

  /// No description provided for @codeInvalid.
  ///
  /// In en, this message translates to:
  /// **'A code is 8 letters and numbers, like ABCD2345.'**
  String get codeInvalid;

  /// No description provided for @checkCode.
  ///
  /// In en, this message translates to:
  /// **'Check the code'**
  String get checkCode;

  /// No description provided for @notAClaimCode.
  ///
  /// In en, this message translates to:
  /// **'This QR code isn\'t a reservation.'**
  String get notAClaimCode;

  /// No description provided for @cameraOffScanMessage.
  ///
  /// In en, this message translates to:
  /// **'Allow the camera for this app in Settings to scan codes, or type the code.'**
  String get cameraOffScanMessage;

  /// No description provided for @cameraFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'The camera didn\'t open'**
  String get cameraFailedTitle;

  /// No description provided for @cameraFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Type the customer\'s code instead.'**
  String get cameraFailedMessage;

  /// No description provided for @pickupsTitle.
  ///
  /// In en, this message translates to:
  /// **'On their way'**
  String get pickupsTitle;

  /// No description provided for @noPickupsTitle.
  ///
  /// In en, this message translates to:
  /// **'No one is on their way'**
  String get noPickupsTitle;

  /// No description provided for @noPickupsMessage.
  ///
  /// In en, this message translates to:
  /// **'Reservations show here until they\'re picked up.'**
  String get noPickupsMessage;

  /// No description provided for @someCustomer.
  ///
  /// In en, this message translates to:
  /// **'A customer'**
  String get someCustomer;

  /// No description provided for @claimTitle.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get claimTitle;

  /// No description provided for @toCollect.
  ///
  /// In en, this message translates to:
  /// **'To collect'**
  String get toCollect;

  /// No description provided for @customerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerLabel;

  /// No description provided for @heldUntil.
  ///
  /// In en, this message translates to:
  /// **'Held until'**
  String get heldUntil;

  /// No description provided for @pickedUpAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get pickedUpAtLabel;

  /// No description provided for @confirmPickup.
  ///
  /// In en, this message translates to:
  /// **'Confirm pickup'**
  String get confirmPickup;

  /// No description provided for @problemRedeemedAt.
  ///
  /// In en, this message translates to:
  /// **'Already picked up: {time}.'**
  String problemRedeemedAt(String time);

  /// No description provided for @problemRedeemed.
  ///
  /// In en, this message translates to:
  /// **'Already picked up.'**
  String get problemRedeemed;

  /// No description provided for @problemCancelled.
  ///
  /// In en, this message translates to:
  /// **'The customer cancelled this reservation.'**
  String get problemCancelled;

  /// No description provided for @problemExpired.
  ///
  /// In en, this message translates to:
  /// **'This reservation has expired.'**
  String get problemExpired;

  /// No description provided for @problemOtherBranch.
  ///
  /// In en, this message translates to:
  /// **'This offer isn\'t for your branch.'**
  String get problemOtherBranch;

  /// No description provided for @problemOther.
  ///
  /// In en, this message translates to:
  /// **'This code can\'t be picked up.'**
  String get problemOther;

  /// No description provided for @claimNotFound.
  ///
  /// In en, this message translates to:
  /// **'No reservation with this code at your store.'**
  String get claimNotFound;

  /// No description provided for @pickedUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get pickedUpTitle;

  /// No description provided for @nextCustomer.
  ///
  /// In en, this message translates to:
  /// **'Next customer'**
  String get nextCustomer;

  /// No description provided for @counterBranch.
  ///
  /// In en, this message translates to:
  /// **'Your branch'**
  String get counterBranch;

  /// No description provided for @chooseCounterBranch.
  ///
  /// In en, this message translates to:
  /// **'Which branch are you at?'**
  String get chooseCounterBranch;

  /// No description provided for @chooseValue.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get chooseValue;

  /// No description provided for @redeemWrongBranch.
  ///
  /// In en, this message translates to:
  /// **'This offer isn\'t valid at the branch picked on this phone.'**
  String get redeemWrongBranch;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @piecesLabel.
  ///
  /// In en, this message translates to:
  /// **'Pieces'**
  String get piecesLabel;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @todayAtBranch.
  ///
  /// In en, this message translates to:
  /// **'Today at your branch'**
  String get todayAtBranch;

  /// No description provided for @statPickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get statPickedUp;

  /// No description provided for @statNotPickedUp.
  ///
  /// In en, this message translates to:
  /// **'Not picked up'**
  String get statNotPickedUp;

  /// No description provided for @statLiveOffers.
  ///
  /// In en, this message translates to:
  /// **'Live offers'**
  String get statLiveOffers;

  /// No description provided for @soonestIn.
  ///
  /// In en, this message translates to:
  /// **'Soonest due in {time}'**
  String soonestIn(String time);

  /// No description provided for @ofClaimsToday.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{of 1 reserved today} other{of {count} reserved today}}'**
  String ofClaimsToday(int count);

  /// No description provided for @notPickedUpHint.
  ///
  /// In en, this message translates to:
  /// **'Their time ran out'**
  String get notPickedUpHint;

  /// No description provided for @almostGone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{One almost gone} other{{count} almost gone}}'**
  String almostGone(int count);

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @hoursShort.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String hoursShort(int hours);

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @seeAllOffers.
  ///
  /// In en, this message translates to:
  /// **'All offers'**
  String get seeAllOffers;

  /// No description provided for @yourLiveOffers.
  ///
  /// In en, this message translates to:
  /// **'Your live offers'**
  String get yourLiveOffers;

  /// No description provided for @liveOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'Live offers'**
  String get liveOffersTitle;

  /// No description provided for @nobodyOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'No one is on their way right now.'**
  String get nobodyOnTheWay;

  /// No description provided for @noLiveOffers.
  ///
  /// In en, this message translates to:
  /// **'No live offers right now.'**
  String get noLiveOffers;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// No description provided for @pickupsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No pickups yet} =1{1 pickup} other{{count} pickups}}'**
  String pickupsCount(int count);

  /// No description provided for @pickupRate.
  ///
  /// In en, this message translates to:
  /// **'{percent}% picked up'**
  String pickupRate(int percent);

  /// No description provided for @soonestFirst.
  ///
  /// In en, this message translates to:
  /// **'Soonest to end first'**
  String get soonestFirst;

  /// No description provided for @pickupsEndNote.
  ///
  /// In en, this message translates to:
  /// **'Reservations stay here until they\'re picked up or their time runs out.'**
  String get pickupsEndNote;

  /// No description provided for @collectFromCustomer.
  ///
  /// In en, this message translates to:
  /// **'Collect from the customer'**
  String get collectFromCustomer;

  /// No description provided for @piecesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 piece} other{{count} pieces}}'**
  String piecesCount(int count);

  /// No description provided for @claimReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get claimReserved;

  /// No description provided for @claimRedeemed.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get claimRedeemed;

  /// No description provided for @claimExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get claimExpired;

  /// No description provided for @claimCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get claimCancelled;

  /// No description provided for @branchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branchLabel;

  /// No description provided for @heldUntilLeft.
  ///
  /// In en, this message translates to:
  /// **'{time} ({left} left)'**
  String heldUntilLeft(String time, String left);

  /// No description provided for @problemRedeemedHint.
  ///
  /// In en, this message translates to:
  /// **'Don\'t hand it over again. If the customer says they didn\'t get it, check with your colleagues.'**
  String get problemRedeemedHint;

  /// No description provided for @problemCancelledHint.
  ///
  /// In en, this message translates to:
  /// **'Don\'t hand it over. The customer can reserve again if the offer is still on.'**
  String get problemCancelledHint;

  /// No description provided for @problemExpiredHint.
  ///
  /// In en, this message translates to:
  /// **'Don\'t hand it over. The customer can reserve again if the offer is still on.'**
  String get problemExpiredHint;

  /// No description provided for @problemOtherBranchHint.
  ///
  /// In en, this message translates to:
  /// **'The customer can pick it up at a branch that has this offer.'**
  String get problemOtherBranchHint;

  /// No description provided for @checkCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Is it the right customer?'**
  String get checkCustomerTitle;

  /// No description provided for @checkCustomerMessage.
  ///
  /// In en, this message translates to:
  /// **'Make sure you handed {item} to {name} and collected {amount}.'**
  String checkCustomerMessage(String item, String name, String amount);

  /// No description provided for @checkCustomerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, picked up'**
  String get checkCustomerConfirm;

  /// No description provided for @perPiece.
  ///
  /// In en, this message translates to:
  /// **'{price} each'**
  String perPiece(String price);

  /// No description provided for @payInCash.
  ///
  /// In en, this message translates to:
  /// **'Paid in cash'**
  String get payInCash;

  /// No description provided for @figureViews.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get figureViews;

  /// No description provided for @figureReserved.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get figureReserved;

  /// No description provided for @figurePickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get figurePickedUp;

  /// No description provided for @endsAt.
  ///
  /// In en, this message translates to:
  /// **'Ends {time}'**
  String endsAt(String time);

  /// No description provided for @dayToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dayToday;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String daysCount(int count);

  /// No description provided for @hoursMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String hoursMinutesShort(int hours, int minutes);

  /// No description provided for @discountOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String discountOff(int percent);
}

class _PartnerLocalizationsDelegate
    extends LocalizationsDelegate<PartnerLocalizations> {
  const _PartnerLocalizationsDelegate();

  @override
  Future<PartnerLocalizations> load(Locale locale) {
    return SynchronousFuture<PartnerLocalizations>(
      lookupPartnerLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_PartnerLocalizationsDelegate old) => false;
}

PartnerLocalizations lookupPartnerLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return PartnerLocalizationsAr();
    case 'en':
      return PartnerLocalizationsEn();
  }

  throw FlutterError(
    'PartnerLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
