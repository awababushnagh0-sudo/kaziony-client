// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'admin_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AdminLocalizationsEn extends AdminLocalizations {
  AdminLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get storePickupInstructions => 'Pickup instructions';

  @override
  String get storePickupInstructionsHint =>
      'e.g. Show your code at the cashier by the door; bring a bag.';

  @override
  String get storeRating => 'Rating';

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
  String get appTitle => 'Kaziony';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle =>
      'Welcome back. Sign in to manage stores and offers.';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Continue';

  @override
  String get wrongCredentials => 'Wrong email or password.';

  @override
  String get accountDisabled => 'This account is disabled.';

  @override
  String get sessionExpired => 'Your session ended. Please sign in again.';

  @override
  String get notAdminAccount =>
      'This dashboard is for our team\'s accounts only.';

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
  String get navHome => 'Home';

  @override
  String get navStores => 'Stores';

  @override
  String get navUsers => 'Users';

  @override
  String get navOffers => 'Offers';

  @override
  String get navCategories => 'Categories';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get comingSoonMessage => 'This page is part of the next steps.';

  @override
  String get statsStores => 'Stores';

  @override
  String statsStoresDetail(int active) {
    return '$active active';
  }

  @override
  String get statsLiveOffers => 'Live offers';

  @override
  String statsLiveOffersDetail(int total) {
    return '$total posted in total';
  }

  @override
  String get statsCustomers => 'Customers';

  @override
  String statsCustomersDetail(int count) {
    return '$count new in the last 7 days';
  }

  @override
  String get statsClaims => 'Claims, last 7 days';

  @override
  String statsClaimsDetail(int percent) {
    return '$percent% of finished claims were picked up';
  }

  @override
  String get statsClaimsNoneFinished => 'No finished claims yet';

  @override
  String get refresh => 'Refresh';

  @override
  String get appSubtitle => 'Admin dashboard';

  @override
  String get storesTitle => 'Stores';

  @override
  String storesTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stores',
      one: '1 store',
    );
    return '$_temp0';
  }

  @override
  String get storesSearch => 'Search by name or area';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterDisabled => 'Disabled';

  @override
  String get columnName => 'Name';

  @override
  String get columnCategory => 'Category';

  @override
  String get columnStatus => 'Status';

  @override
  String get columnAdded => 'Added';

  @override
  String get storeActive => 'Active';

  @override
  String get storeDisabled => 'Disabled';

  @override
  String get storesEmpty => 'No stores yet';

  @override
  String get storesEmptyMessage =>
      'Add the first store and give its owner their login.';

  @override
  String get listNoResults => 'No matches';

  @override
  String get listNoResultsMessage => 'Try another search or clear the filters.';

  @override
  String pageOf(int page, int pages) {
    return 'Page $page of $pages';
  }

  @override
  String get previousPage => 'Previous page';

  @override
  String get nextPage => 'Next page';

  @override
  String get addStore => 'Add store';

  @override
  String get addStoreTitle => 'New store';

  @override
  String get createStore => 'Create store';

  @override
  String get sectionStore => 'Store';

  @override
  String get sectionPlace => 'Place';

  @override
  String get sectionHours => 'Opening hours';

  @override
  String get sectionOwner => 'Owner account';

  @override
  String get storeName => 'Store name';

  @override
  String get storeCategory => 'Category';

  @override
  String get storeCategoryHint => 'Choose';

  @override
  String get storePhone => 'Store phone';

  @override
  String get storeEmail => 'Store email';

  @override
  String get tabDetails => 'Details';

  @override
  String get tabContact => 'Contact';

  @override
  String get storeFacebook => 'Facebook';

  @override
  String get storeInstagram => 'Instagram';

  @override
  String get storeTeam => 'Team';

  @override
  String get save => 'Save';

  @override
  String get notSaved => 'Not saved';

  @override
  String get savedDone => 'Saved';

  @override
  String get discardChangesTitle => 'Discard your changes?';

  @override
  String get discardChangesMessage =>
      'Your changes haven\'t been saved. Leave without saving?';

  @override
  String get discardChanges => 'Discard';

  @override
  String get actions => 'Actions';

  @override
  String get disableStore => 'Disable store';

  @override
  String get disableStoreHint => 'Hide it from customers';

  @override
  String get enableStore => 'Enable store';

  @override
  String get deleteStore => 'Delete store';

  @override
  String get deleteStoreHint => 'Only for stores without offers';

  @override
  String disableStoreTitle(String store) {
    return 'Disable $store?';
  }

  @override
  String get disableStoreMessage =>
      'Customers won\'t see the store or its offers, and its team can\'t post new ones. You can enable it again at any time.';

  @override
  String disableStoreOffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Its $count live offers are hidden with it.',
      one: 'Its live offer is hidden with it.',
    );
    return '$_temp0';
  }

  @override
  String disableStoreBookings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count bookings are waiting to be picked up. They stay valid, and a missed one won\'t count against the customer.',
      one: '1 booking is waiting to be picked up. It stays valid, and if the customer misses it, it won\'t count against them.',
    );
    return '$_temp0';
  }

  @override
  String get cancelStoreBookings => 'Cancel its bookings';

  @override
  String get cancelStoreBookingsHint =>
      'Customers are told why, and it doesn\'t count against them';

  @override
  String cancelStoreBookingsTitle(int count, String store) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cancel the $count bookings waiting at $store?',
      one: 'Cancel the booking waiting at $store?',
    );
    return '$_temp0';
  }

  @override
  String get cancelStoreBookingsMessage =>
      'Each customer is told why in the app, and it doesn\'t count against them; the pieces go back to the offers. Or keep them: they stay valid for pickup.';

  @override
  String get cancelBookingsConfirm => 'Cancel the bookings';

  @override
  String get hoursCancelBookingsTitle =>
      'Cancel the bookings these hours miss?';

  @override
  String get hoursCancelBookingsMessage =>
      'Some bookings at this store are due after its new closing time. Saving cancels them, and their customers are told. It doesn\'t count against them.';

  @override
  String get hoursCancelBookingsConfirm => 'Save and cancel them';

  @override
  String get keepBookings => 'Keep them';

  @override
  String bookingsCancelledDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bookings cancelled: their customers were told',
      one: 'Booking cancelled: its customer was told',
    );
    return '$_temp0';
  }

  @override
  String get noBookingsWaiting => 'No bookings are waiting at this store';

  @override
  String deleteStoreTitle(String store) {
    return 'Delete $store?';
  }

  @override
  String get deleteStoreMessage =>
      'The store and its products are deleted for good. Its team keeps their accounts, and the brand\'s other places stay.';

  @override
  String get storeDisabledDone => 'Store disabled';

  @override
  String get storeEnabledDone => 'Store enabled';

  @override
  String get storeDeletedDone => 'Store deleted';

  @override
  String get storeHasOffers =>
      'This store has offers, so it can\'t be deleted. Disable it instead.';

  @override
  String get placeCity => 'City';

  @override
  String get cityTripoli => 'Tripoli';

  @override
  String get placeArea => 'Area';

  @override
  String get placeAreaHint => 'e.g. Hay Al Andalus';

  @override
  String get placeAreaHelp =>
      'Shown with the store\'s name, so a brand\'s places can be told apart.';

  @override
  String get placeAddress => 'Address';

  @override
  String get placeLocation => 'Location';

  @override
  String get placeLocationHelp =>
      'Paste a Google Maps link, or coordinates like 32.8872, 13.1913';

  @override
  String get hoursNote =>
      'Times like 08:00-23:00, or with a break 08:00-13:00, 16:00-23:00. Write - for a day closed; a day left empty isn\'t shown to customers.';

  @override
  String get invalidHours => 'Write times like 08:00-23:00, at most 4 a day.';

  @override
  String get daySat => 'Saturday';

  @override
  String get daySun => 'Sunday';

  @override
  String get dayMon => 'Monday';

  @override
  String get dayTue => 'Tuesday';

  @override
  String get dayWed => 'Wednesday';

  @override
  String get dayThu => 'Thursday';

  @override
  String get dayFri => 'Friday';

  @override
  String get addLocation => 'Add another location';

  @override
  String get addLocationHint =>
      'Same name, photos and owners, at another place';

  @override
  String addLocationTitle(String store) {
    return 'New location of $store';
  }

  @override
  String get addLocationNote =>
      'It\'s a store of its own, and gets this one\'s name, photos, category, contact links, pickup instructions and owners.';

  @override
  String get addLocationButton => 'Add location';

  @override
  String get locationPhone => 'Phone of this location';

  @override
  String get locationPhoneHelp => 'Leave it empty to use this store\'s phone.';

  @override
  String get locationAddedDone => 'Location added';

  @override
  String get invalidLocation =>
      'Couldn\'t read a location from this link. Paste a Google Maps link or the coordinates.';

  @override
  String get locationOutsideLibya => 'This location is outside Libya.';

  @override
  String locationFound(String latitude, String longitude) {
    return 'Location found: $latitude, $longitude';
  }

  @override
  String get locationUnchecked =>
      'Couldn\'t check the link. Check your connection and try again.';

  @override
  String get ownerName => 'Owner name';

  @override
  String get ownerPhone => 'Owner phone';

  @override
  String get ownerPhoneHelp =>
      'The owner logs in to the store app with this number.';

  @override
  String get phoneTakenByCustomer =>
      'This number belongs to a customer account. Use another number for the store owner.';

  @override
  String get categoriesFailed => 'Couldn\'t load the categories.';

  @override
  String get storeCreatedTitle => 'Store created';

  @override
  String storeCreatedMessage(String store) {
    return 'Give these details to the owner of $store. They will choose their own password when they first log in.';
  }

  @override
  String get loginPhone => 'Login phone';

  @override
  String get temporaryPassword => 'Temporary password';

  @override
  String get passwordShownOnce =>
      'The password is shown only now. Copy it before closing.';

  @override
  String ownerLinkedMessage(String store) {
    return 'This number already had a store account, so it was added as the owner of $store. They log in with their current password.';
  }

  @override
  String get done => 'Done';

  @override
  String get usersTitle => 'Users';

  @override
  String usersTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users',
      one: '1 user',
    );
    return '$_temp0';
  }

  @override
  String get usersSearch => 'Search by name or email';

  @override
  String get usersEmpty => 'No users yet';

  @override
  String get usersEmptyMessage =>
      'Add the people on your team who use this dashboard.';

  @override
  String get filterAdmins => 'Admins';

  @override
  String get filterEditors => 'Editors';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleEditor => 'Editor';

  @override
  String get columnEmail => 'Email';

  @override
  String get columnRole => 'Role';

  @override
  String get columnLastLogin => 'Last login';

  @override
  String get neverLoggedIn => 'Never';

  @override
  String get userActive => 'Active';

  @override
  String get userDisabled => 'Disabled';

  @override
  String get addUser => 'Add user';

  @override
  String get addUserTitle => 'Add a user';

  @override
  String get userName => 'Name';

  @override
  String get userEmail => 'Email';

  @override
  String get userEmailHelp => 'They log in with it.';

  @override
  String get userRole => 'Role';

  @override
  String get userRoleHelp =>
      'Editors can add and edit, but can\'t delete or manage users.';

  @override
  String get emailTaken => 'This email already has an account.';

  @override
  String get userCreatedTitle => 'User added';

  @override
  String userCreatedMessage(String name) {
    return 'Give these details to $name. They will choose their own password when they first log in.';
  }

  @override
  String get loginEmail => 'Login email';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordHint => 'Give them a new temporary password';

  @override
  String resetPasswordTitle(String name) {
    return 'Reset $name\'s password?';
  }

  @override
  String get resetPasswordMessage =>
      'They\'ll get a new temporary password and be logged out everywhere. Their current password stops working.';

  @override
  String get newPasswordTitle => 'New password';

  @override
  String newPasswordMessage(String name) {
    return 'Give this to $name. They will choose their own password when they next log in.';
  }

  @override
  String get disableUser => 'Disable user';

  @override
  String get disableUserHint => 'Log them out and stop them logging in';

  @override
  String get enableUser => 'Enable user';

  @override
  String disableUserTitle(String name) {
    return 'Disable $name?';
  }

  @override
  String get disableUserMessage =>
      'They\'re logged out everywhere and can\'t log in until you enable them again.';

  @override
  String get userDisabledDone => 'User disabled';

  @override
  String get userEnabledDone => 'User enabled';

  @override
  String get settings => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsAppearanceHint =>
      'How the dashboard looks on this device.';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeHint =>
      'Automatic follows your device\'s light or dark setting.';

  @override
  String get themeSystem => 'Automatic';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageHint =>
      'The dashboard\'s language on this device. Arabic reads right to left.';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get navPlatform => 'Platform settings';

  @override
  String get platformSettingsTitle => 'Platform settings';

  @override
  String get platformOffersSection => 'Offers and reservations';

  @override
  String get browseRadiusLabel => 'Offer radius (km)';

  @override
  String browseRadiusHint(int min, int max) {
    return 'Customers see offers from stores within this distance of them, $min to $max km. Takes effect right away.';
  }

  @override
  String get browseRadiusEditorHint =>
      'Customers see offers from stores within this distance of them. Only admins change it.';

  @override
  String get holdMinutesLabel => 'Hold for pickup (minutes)';

  @override
  String holdMinutesHint(int min, int max) {
    return 'How long a reservation waits for the customer to pick it up, $min to $max minutes, unless the offer ends first. Reservations already made keep theirs.';
  }

  @override
  String get holdMinutesEditorHint =>
      'How long a reservation waits for the customer to pick it up. Only admins change it.';

  @override
  String get platformAreasSection => 'Service areas';

  @override
  String get serviceAreasHelp =>
      'Customers can only browse offers from inside these circles; the app draws them on its map.';

  @override
  String get addServiceArea => 'Add area';

  @override
  String get addServiceAreaTitle => 'New service area';

  @override
  String get editServiceAreaTitle => 'Edit service area';

  @override
  String get serviceAreaNameAr => 'Name in Arabic';

  @override
  String get serviceAreaNameEn => 'Name in English';

  @override
  String get serviceAreaCenter => 'Center';

  @override
  String get serviceAreaCenterHelp =>
      'From Google Maps: click the city\'s center and copy its coordinates.';

  @override
  String get invalidCoordinates =>
      'Enter latitude then longitude, like 32.85, 13.18';

  @override
  String get serviceAreaRadius => 'Radius (km)';

  @override
  String serviceAreaRadiusHint(int min, int max) {
    return '$min to $max km around the center.';
  }

  @override
  String get serviceAreaOn => 'On';

  @override
  String get serviceAreaOff => 'Off';

  @override
  String serviceAreasTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count areas',
      one: '1 area',
    );
    return '$_temp0';
  }

  @override
  String get deleteServiceArea => 'Delete area';

  @override
  String deleteServiceAreaTitle(String area) {
    return 'Delete $area?';
  }

  @override
  String get deleteServiceAreaMessage =>
      'Customers there won\'t be able to browse offers. To pause it, turn it off instead.';

  @override
  String get navSearches => 'Searches';

  @override
  String get searchesTitle => 'What customers search for';

  @override
  String get searchesSearch => 'Search the searches';

  @override
  String searchesTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count searches',
      one: '1 search',
    );
    return '$_temp0';
  }

  @override
  String get searchesEmpty => 'No searches yet';

  @override
  String get searchesEmptyMessage =>
      'What customers search for in the app shows here, the most searched first.';

  @override
  String get filterNothingFound => 'Found nothing';

  @override
  String get filterFound => 'Found offers';

  @override
  String get columnSearch => 'Search';

  @override
  String get columnSearchCount => 'Times searched';

  @override
  String get columnFound => 'Last found';

  @override
  String get columnLastSearched => 'Last searched';

  @override
  String get foundNothing => 'Nothing';

  @override
  String foundOffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count offers',
      one: '1 offer',
    );
    return '$_temp0';
  }

  @override
  String get navSystem => 'System';

  @override
  String get systemTitle => 'System';

  @override
  String get systemTabOverview => 'Overview';

  @override
  String get systemTabTraffic => 'Traffic';

  @override
  String get systemTabErrors => 'Errors';

  @override
  String get systemTabJobs => 'Jobs';

  @override
  String get systemTabDatabase => 'Database';

  @override
  String get systemRedis => 'Redis (shared cache)';

  @override
  String get systemInstances => 'Instances';

  @override
  String get systemCheckedAt => 'Checked';

  @override
  String systemCheckedAtValue(String time) {
    return '$time · every 15 seconds';
  }

  @override
  String get systemAllGood => 'Everything is running';

  @override
  String get systemNeedsAttention => 'Something needs a look';

  @override
  String get healthUp => 'Up';

  @override
  String get healthDown => 'Down';

  @override
  String get healthOff => 'Not set up';

  @override
  String unitMs(String value) {
    return '$value ms';
  }

  @override
  String unitKb(String value) {
    return '$value KB';
  }

  @override
  String unitMb(String value) {
    return '$value MB';
  }

  @override
  String unitGb(String value) {
    return '$value GB';
  }

  @override
  String unitPercent(String value) {
    return '$value%';
  }

  @override
  String uptimeMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String uptimeHours(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String uptimeDays(int days, int hours) {
    return '$days d $hours h';
  }

  @override
  String get figureRequestsPerMinute => 'Requests a minute';

  @override
  String get figureServerErrors => 'Server errors';

  @override
  String figureServerErrorsHint(int count) {
    return '$count in 5 minutes';
  }

  @override
  String get figureLatency => 'Response time (p95)';

  @override
  String get figureLast5Minutes => 'Last 5 minutes';

  @override
  String get figureErrorKinds => 'Kinds of errors';

  @override
  String get figureLastDay => 'Last 24 hours';

  @override
  String figureFailingJobs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jobs failing',
      one: '1 job failing',
      zero: 'No job failing',
    );
    return '$_temp0';
  }

  @override
  String get instanceThisOne => 'Answered';

  @override
  String instanceSubtitle(String version, String uptime) {
    return 'Version $version · up $uptime';
  }

  @override
  String get instanceMemory => 'Memory';

  @override
  String instanceMemoryValue(String total, String heap) {
    return '$total ($heap in use by JavaScript)';
  }

  @override
  String get instanceCpu => 'Processor';

  @override
  String get instanceEventLoop => 'Event loop delay';

  @override
  String get instanceConnections => 'Database connections';

  @override
  String instanceConnectionsValue(int open, int idle, int waiting, int max) {
    return '$open open · $idle idle · $waiting waiting · up to $max';
  }

  @override
  String get instanceRequests => 'Requests a minute';

  @override
  String get instanceStarted => 'Started';

  @override
  String get instanceReported => 'Last report';

  @override
  String trafficWindow(int minutes) {
    return '$minutes min';
  }

  @override
  String trafficSummary(int requests, int errors, int minutes) {
    return '$requests requests and $errors server errors in the last $minutes minutes';
  }

  @override
  String trafficMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String get trafficNow => 'Now';

  @override
  String trafficBar(String time, int requests, int errors) {
    return '$time · $requests requests · $errors errors';
  }

  @override
  String get trafficRoutes => 'Routes, busiest first';

  @override
  String trafficRouteLatency(String p50, String p95, String p99) {
    return 'p50 $p50 · p95 $p95 · p99 $p99';
  }

  @override
  String trafficRouteErrors(String latency, int errors, int refused) {
    return '$latency · $errors server errors · $refused refused';
  }

  @override
  String get trafficEmpty => 'No requests yet';

  @override
  String get trafficEmptyMessage =>
      'Requests show here as the apps use the API.';

  @override
  String get errorsEmpty => 'No server errors';

  @override
  String get errorsEmptyMessage =>
      'Errors of the last 24 hours show here, the same error on the same route as one.';

  @override
  String errorTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      one: 'once',
    );
    return '$_temp0';
  }

  @override
  String errorSubtitle(String route, String times, String when) {
    return '$route · $times · last $when';
  }

  @override
  String get errorRequestId => 'Last request id (finds it in the logs)';

  @override
  String get errorFirstSeen => 'First seen';

  @override
  String get errorLastSeen => 'Last seen';

  @override
  String get errorStack => 'Where it happened';

  @override
  String get jobRunNow => 'Run now';

  @override
  String jobRan(String duration) {
    return 'Done in $duration';
  }

  @override
  String get jobRanFailed => 'The job failed: its last error says why.';

  @override
  String get jobAlreadyRunning => 'This job is running right now.';

  @override
  String get jobSucceeded => 'Succeeded';

  @override
  String get jobFailed => 'Failed';

  @override
  String get jobRunning => 'Running';

  @override
  String get jobNeverRun => 'Not run yet';

  @override
  String get jobSchedule => 'Schedule (cron)';

  @override
  String get jobByHand => 'Only by hand';

  @override
  String get jobNextRun => 'Next run';

  @override
  String get jobLastRun => 'Last run';

  @override
  String jobLastRunValue(String when, String duration) {
    return '$when · $duration';
  }

  @override
  String get jobLastResult => 'What it did';

  @override
  String get jobRuns => 'Runs';

  @override
  String jobRunsValue(int runs, int failures) {
    return '$runs ($failures failed)';
  }

  @override
  String get jobLastError => 'Last error';

  @override
  String get jobsEmpty => 'No jobs';

  @override
  String get dbSize => 'Size';

  @override
  String get dbConnections => 'Connections';

  @override
  String dbConnectionsHint(int active, int max) {
    return '$active active · up to $max';
  }

  @override
  String get dbCacheHit => 'Read from memory';

  @override
  String get dbCacheHitHint => 'Below 99%, it needs more memory';

  @override
  String get dbWaiting => 'Waiting';

  @override
  String dbWaitingHint(int locks, int idle) {
    return '$locks on locks · $idle idle in a transaction';
  }

  @override
  String dbVersion(String version) {
    return 'Postgres $version';
  }

  @override
  String get dbStatementsOff => 'Query timings are off';

  @override
  String get dbStatementsOffMessage =>
      'Load pg_stat_statements in Postgres to see the queries taking the most time.';

  @override
  String get dbRunning => 'Running for over a second';

  @override
  String dbRunningWaiting(String duration, String what) {
    return '$duration · waiting for $what';
  }

  @override
  String get dbSlowest => 'Taking the most time';

  @override
  String dbQueryStats(int calls, String mean, String total) {
    return '$calls runs · $mean each · $total in all';
  }

  @override
  String get dbTables => 'Tables, biggest first';

  @override
  String dbTableRows(int rows, int dead) {
    return '$rows rows · $dead waiting for cleanup';
  }

  @override
  String get systemStatus => 'Status';

  @override
  String get jobExpireClaims =>
      'Expires missed pickups: the pieces go back on sale and the customer gets a strike; 3 pause booking for 3 days (7 after a recent pause). Closes deliveries left open a day as delivered, and ends offers whose time is up.';

  @override
  String get jobExpireClaimsBacklog => 'Bookings past their time';

  @override
  String get jobCleanTokens =>
      'Deletes sign-in tokens that ran out, or were used or revoked over 7 days ago.';

  @override
  String get jobCleanTokensBacklog => 'Tokens to delete';

  @override
  String get jobCleanSearchTerms =>
      'Deletes searches made fewer than 3 times, and not in the last 90 days.';

  @override
  String get jobCleanSearchTermsBacklog => 'Searches to delete';

  @override
  String get navActivity => 'Activity';

  @override
  String get activityTitle => 'Who changed what';

  @override
  String get activitySearch => 'Search by name';

  @override
  String activityTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes',
      one: '1 change',
    );
    return '$_temp0';
  }

  @override
  String get activityEmpty => 'No changes yet';

  @override
  String get activityEmptyMessage =>
      'Every change made in the dashboard shows here: who made it, and when.';

  @override
  String get activityAreaServiceAreas => 'Service areas';

  @override
  String get activityAreaSettings => 'Settings';

  @override
  String get activityAreaJobs => 'Jobs';

  @override
  String get columnWhen => 'When';

  @override
  String get columnWho => 'Who';

  @override
  String get columnWhat => 'What';

  @override
  String get columnItem => 'Item';

  @override
  String get columnFields => 'Fields';

  @override
  String get activityRemovedAccount => 'A removed account';

  @override
  String get activityRequestId => 'Request id (finds it in the logs)';

  @override
  String get activitySent => 'What was sent';

  @override
  String get activityNothingSent => 'Nothing was sent';

  @override
  String get activityStoreCreate => 'Added a store';

  @override
  String get activityStoreUpdate => 'Edited a store';

  @override
  String get activityStoreDelete => 'Deleted a store';

  @override
  String get activityStoreAddLocation => 'Added a location';

  @override
  String get activityStoreAddMember => 'Added someone to a store';

  @override
  String get activityStoreRemoveMember => 'Removed someone from a store';

  @override
  String get activityStoreSetImage => 'Changed a store\'s photo';

  @override
  String get activityStoreRemoveImage => 'Removed a store\'s photo';

  @override
  String get activityStoreCancelBookings => 'Cancelled a store\'s bookings';

  @override
  String get activityUserCreate => 'Added a team member';

  @override
  String get activityUserUpdate => 'Edited an account';

  @override
  String get activityUserDisable => 'Disabled an account';

  @override
  String get activityUserEnable => 'Enabled an account';

  @override
  String get activityUserResetPassword => 'Reset a password';

  @override
  String get activityCategoryCreate => 'Added a category';

  @override
  String get activityCategoryUpdate => 'Edited a category';

  @override
  String get activityServiceAreaCreate => 'Added a service area';

  @override
  String get activityServiceAreaUpdate => 'Edited a service area';

  @override
  String get activityServiceAreaDelete => 'Deleted a service area';

  @override
  String get activitySettingsUpdate => 'Changed the platform settings';

  @override
  String get activityOfferRemove => 'Took an offer down';

  @override
  String get activityJobRun => 'Ran a job by hand';

  @override
  String get storePhoneHelp => 'Customers call it about their pickup.';

  @override
  String get goLiveTitle => 'Before customers see it';

  @override
  String get goLiveNote =>
      'Customers see the store once it\'s turned on, and it can\'t be turned on before these are done.';

  @override
  String get goLiveLogo => 'Logo';

  @override
  String get goLiveLogoWhere =>
      'On the Photos tab, or added by the owner in the store app.';

  @override
  String get goLivePickupWhere =>
      'On the Details tab, or written by the owner.';

  @override
  String get goLiveHoursWhere =>
      'Every day, open or closed: on the Place tab, or set by the owner.';

  @override
  String get goLiveHours => 'Hours for every day';

  @override
  String get goLiveDone => 'Done';

  @override
  String get goLiveMissing => 'Missing';

  @override
  String get tabPhotos => 'Photos';

  @override
  String get storePhotosNote =>
      'Customers see the logo by the store\'s name and the cover across the top of its page. Click one to choose a photo from your computer: it\'s uploaded right away.';

  @override
  String get storeLogo => 'Logo';

  @override
  String get storeCover => 'Cover photo';

  @override
  String get addLogo => 'Add a logo';

  @override
  String get addCover => 'Add a cover photo';

  @override
  String get coverHint => 'The shop front or what it sells';

  @override
  String get removeLogo => 'Remove the logo';

  @override
  String get removeCover => 'Remove the cover';

  @override
  String removeLogoTitle(String store) {
    return 'Remove $store\'s logo?';
  }

  @override
  String removeCoverTitle(String store) {
    return 'Remove $store\'s cover photo?';
  }

  @override
  String get removePhotoMessage =>
      'Customers won\'t see it any more. You can add another one any time.';

  @override
  String get photoRemovedDone => 'Photo removed';

  @override
  String get liveStoreKeepsLogo =>
      'A live store keeps its logo: it can be changed, not removed.';

  @override
  String get photoTooLarge =>
      'This photo is over 1 MB. Choose a smaller one, or a JPEG.';

  @override
  String enableStoreNeeds(String items) {
    return 'Needs: $items';
  }

  @override
  String get storeNotReady =>
      'A store customers see needs a logo, pickup instructions and opening hours.';

  @override
  String get storeReadyToGoLive => 'Ready to turn on';

  @override
  String get storeNotReadyBadge => 'Not ready';

  @override
  String get storeHiddenTitle => 'Customers can\'t see it yet';

  @override
  String get storeHiddenMessage =>
      'Turn it on from its page once it has a logo, pickup instructions and opening hours. The owner can add them from the store app.';

  @override
  String disableStoreDeliveries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count bookings are out with the store\'s drivers. They\'re left to the store to close.',
      one: '1 booking is out with the store\'s driver. It\'s left to the store to close.',
    );
    return '$_temp0';
  }

  @override
  String get sectionDelivery => 'Delivery';

  @override
  String get deliveryNote =>
      'For stores with their own drivers. Customers with a booking call to have it brought; delivery and any fee are between them and the store.';

  @override
  String get storeDelivery => 'Delivery';

  @override
  String get deliveryPickupOnly => 'Pickup only';

  @override
  String get deliveryToo => 'Delivers too';

  @override
  String get storeDeliveryPhone => 'Number for delivery';

  @override
  String get storeDeliveryPhoneHelp =>
      'Empty: customers call the store\'s phone.';

  @override
  String get navReports => 'Reports';

  @override
  String get reportsTitle => 'Customer reports';

  @override
  String get reportsSearch => 'Search by booking code, store or customer';

  @override
  String reportsTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reports',
      one: '1 report',
    );
    return '$_temp0';
  }

  @override
  String get reportsEmpty => 'No reports';

  @override
  String get reportsEmptyMessage =>
      'When a customer reports a problem with a booking, it shows here for the team to look into.';

  @override
  String get filterOpen => 'Open';

  @override
  String get filterResolved => 'Resolved';

  @override
  String get columnCustomer => 'Customer';

  @override
  String get columnStore => 'Store';

  @override
  String get columnReason => 'Reason';

  @override
  String get reportReasonStoreClosed => 'The store was closed';

  @override
  String get reportReasonNotGiven => 'The store didn\'t give the booking';

  @override
  String get reportReasonPriceDifferent => 'Asked to pay more';

  @override
  String get reportReasonQuality => 'Something was wrong with it';

  @override
  String get reportReasonOther => 'Something else';

  @override
  String get reportCustomerSaid => 'What the customer said';

  @override
  String get reportBooking => 'The booking';

  @override
  String get reportCode => 'Code';

  @override
  String get reportOffer => 'Offer';

  @override
  String reportPieces(int count, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pieces · $price',
      one: '1 piece · $price',
    );
    return '$_temp0';
  }

  @override
  String get reportPiecesLabel => 'Pieces';

  @override
  String get reportBookingStatus => 'Status';

  @override
  String get reportBooked => 'Booked';

  @override
  String get reportPickUpBy => 'To pick up by';

  @override
  String get bookingWaiting => 'Waiting to be picked up';

  @override
  String get bookingOutForDelivery => 'Out for delivery';

  @override
  String get bookingPickedUp => 'Picked up';

  @override
  String get bookingMissed => 'Missed';

  @override
  String get bookingCancelled => 'Cancelled';

  @override
  String get reportCustomer => 'The customer';

  @override
  String get reportDeletedAccount => 'Deleted their account';

  @override
  String get reportPhone => 'Phone';

  @override
  String get reportMissedPickups => 'Missed pickups';

  @override
  String get reportPausedUntil => 'Booking paused until';

  @override
  String get reportOpenStore => 'Open the store';

  @override
  String get reportTakeBack => 'What to take back';

  @override
  String get reportRemoveStrike => 'This booking\'s strike';

  @override
  String get reportRemoveStrikeOn =>
      'Taken back: their missed pickups go down by one';

  @override
  String get reportRemoveStrikeOff => 'Stays';

  @override
  String get reportEndPause => 'Their pause in booking';

  @override
  String get reportEndPauseOn => 'Ended now: they can book again';

  @override
  String reportEndPauseOff(String date) {
    return 'Stays until $date';
  }

  @override
  String get reportNoStrike => 'This booking gave no strike.';

  @override
  String get reportNothingToTakeBack =>
      'This booking gave no strike and the customer isn\'t paused: resolving closes the report.';

  @override
  String get reportResolution => 'What you found';

  @override
  String get reportResolutionHint =>
      'For the team: what the store or the customer said';

  @override
  String get reportResolve => 'Resolve';

  @override
  String get reportResolvedDone => 'Report resolved';

  @override
  String get reportDecision => 'What the team decided';

  @override
  String get reportResolvedBy => 'Resolved by';

  @override
  String get reportTakenBack => 'Taken back';

  @override
  String get reportTakenBoth => 'The strike and the pause';

  @override
  String get reportTakenStrike => 'The strike';

  @override
  String get reportTakenPause => 'The pause';

  @override
  String get reportTakenNothing => 'Nothing';

  @override
  String get reportAlreadyResolved =>
      'Someone on the team resolved this report first.';

  @override
  String get reportStrikeGone =>
      'This booking\'s strike was already taken back.';

  @override
  String get reportPauseOver => 'The customer\'s pause has already ended.';

  @override
  String get activityReportResolve => 'Resolved a customer report';

  @override
  String get errorAccountDeleted => 'This account was deleted by its owner.';

  @override
  String get errorEmailTaken => 'This email already has an account.';

  @override
  String get errorPhoneTaken =>
      'This phone number belongs to a customer, not a store account.';

  @override
  String get errorAlreadyMember => 'They\'re already on this store\'s team.';

  @override
  String get errorStoreIsLive =>
      'Turn the store off before cancelling its bookings.';
}
