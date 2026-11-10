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
  String get appTitle => 'Offers Admin';

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
  String get storesSearch => 'Search by name';

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
  String get columnBranches => 'Branches';

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
  String get sectionBranch => 'First branch';

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
  String deleteStoreTitle(String store) {
    return 'Delete $store?';
  }

  @override
  String get deleteStoreMessage =>
      'The store, its branches and its products are deleted for good. Its team keeps their accounts.';

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
  String get branchName => 'Branch name';

  @override
  String get branchNameHint => 'e.g. Hay Al Andalus';

  @override
  String get branchCity => 'City';

  @override
  String get cityTripoli => 'Tripoli';

  @override
  String get branchArea => 'Area';

  @override
  String get branchAddress => 'Address';

  @override
  String get branchLocation => 'Location';

  @override
  String get branchLocationHelp =>
      'Paste a Google Maps link, or coordinates like 32.8872, 13.1913';

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
  String get platformBrowseSection => 'Browsing offers';

  @override
  String get browseRadiusLabel => 'Offer radius (km)';

  @override
  String browseRadiusHint(int min, int max) {
    return 'Customers see offers from branches within this distance of them, $min to $max km. Takes effect right away.';
  }

  @override
  String get browseRadiusEditorHint =>
      'Customers see offers from branches within this distance of them. Only admins change it.';

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
      'Expires missed pickups: the pieces go back on sale, the customer gets a strike, every third one blocks booking for 7 days. Ends offers whose time is up.';

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
  String get activityStoreAddBranch => 'Added a branch';

  @override
  String get activityStoreUpdateBranch => 'Edited a branch';

  @override
  String get activityStoreAddMember => 'Added someone to a store';

  @override
  String get activityStoreRemoveMember => 'Removed someone from a store';

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
}
