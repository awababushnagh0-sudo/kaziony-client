// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'admin_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AdminLocalizationsAr extends AdminLocalizations {
  AdminLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get storePickupInstructions => 'تعليمات الاستلام';

  @override
  String get storePickupInstructionsHint =>
      'مثال: اعرض رمزك عند الكاشير قرب الباب، وأحضر كيسًا.';

  @override
  String get storeRating => 'التقييم';

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
      other: '$count تقييم',
      many: '$count تقييمًا',
      few: '$count تقييمات',
      two: 'تقييمان',
      one: 'تقييم واحد',
    );
    return '★ $averageString · $_temp0';
  }

  @override
  String get noRatingsYet => 'لا توجد تقييمات بعد';

  @override
  String get appTitle => 'كزيوني';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle =>
      'مرحباً بعودتك. سجّل الدخول لإدارة المتاجر والعروض.';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'متابعة';

  @override
  String get wrongCredentials => 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get accountDisabled => 'هذا الحساب موقوف.';

  @override
  String get sessionExpired => 'انتهت الجلسة. سجّل الدخول مرة أخرى.';

  @override
  String get notAdminAccount => 'لوحة التحكم هذه لحسابات فريقنا فقط.';

  @override
  String get changePasswordTitle => 'اختر كلمة مرور جديدة';

  @override
  String get changePasswordSubtitle =>
      'أنت تستخدم كلمة مرور مؤقتة. اختر كلمة مرور خاصة بك للمتابعة.';

  @override
  String get currentPasswordLabel => 'كلمة المرور المؤقتة';

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get confirmPasswordLabel => 'أعد كتابة كلمة المرور الجديدة';

  @override
  String get savePasswordButton => 'حفظ ومتابعة';

  @override
  String get wrongCurrentPassword => 'كلمة المرور المؤقتة غير صحيحة.';

  @override
  String get passwordChanged => 'تم تغيير كلمة المرور.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navStores => 'المتاجر';

  @override
  String get navUsers => 'المستخدمون';

  @override
  String get navOffers => 'العروض';

  @override
  String get navCategories => 'التصنيفات';

  @override
  String get comingSoonTitle => 'قريباً';

  @override
  String get comingSoonMessage => 'هذه الصفحة ضمن الخطوات القادمة.';

  @override
  String get statsStores => 'المتاجر';

  @override
  String statsStoresDetail(int active) {
    return '$active نشط';
  }

  @override
  String get statsLiveOffers => 'العروض المتاحة الآن';

  @override
  String statsLiveOffersDetail(int total) {
    return '$total عرض منشور إجمالاً';
  }

  @override
  String get statsCustomers => 'الزبائن';

  @override
  String statsCustomersDetail(int count) {
    return '$count جديد خلال آخر 7 أيام';
  }

  @override
  String get statsClaims => 'الحجوزات خلال آخر 7 أيام';

  @override
  String statsClaimsDetail(int percent) {
    return 'تم استلام $percent٪ من الحجوزات المنتهية';
  }

  @override
  String get statsClaimsNoneFinished => 'لا توجد حجوزات منتهية بعد';

  @override
  String get refresh => 'تحديث';

  @override
  String get appSubtitle => 'لوحة التحكم';

  @override
  String get storesTitle => 'المتاجر';

  @override
  String storesTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count متجر',
      few: '$count متاجر',
      two: 'متجران',
      one: 'متجر واحد',
      zero: 'لا متاجر',
    );
    return '$_temp0';
  }

  @override
  String get storesSearch => 'ابحث بالاسم أو المنطقة';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterActive => 'نشطة';

  @override
  String get filterDisabled => 'موقوفة';

  @override
  String get columnName => 'الاسم';

  @override
  String get columnCategory => 'التصنيف';

  @override
  String get columnStatus => 'الحالة';

  @override
  String get columnAdded => 'تاريخ الإضافة';

  @override
  String get storeActive => 'نشط';

  @override
  String get storeDisabled => 'موقوف';

  @override
  String get storesEmpty => 'لا توجد متاجر بعد';

  @override
  String get storesEmptyMessage => 'أضف أول متجر وأعطِ صاحبه بيانات الدخول.';

  @override
  String get listNoResults => 'لا توجد نتائج مطابقة';

  @override
  String get listNoResultsMessage => 'جرّب بحثاً آخر أو امسح عوامل التصفية.';

  @override
  String pageOf(int page, int pages) {
    return 'صفحة $page من $pages';
  }

  @override
  String get previousPage => 'الصفحة السابقة';

  @override
  String get nextPage => 'الصفحة التالية';

  @override
  String get addStore => 'إضافة متجر';

  @override
  String get addStoreTitle => 'متجر جديد';

  @override
  String get createStore => 'إنشاء المتجر';

  @override
  String get sectionStore => 'المتجر';

  @override
  String get sectionPlace => 'المكان';

  @override
  String get sectionHours => 'أوقات العمل';

  @override
  String get sectionOwner => 'حساب صاحب المتجر';

  @override
  String get storeName => 'اسم المتجر';

  @override
  String get storeCategory => 'التصنيف';

  @override
  String get storeCategoryHint => 'اختر';

  @override
  String get storePhone => 'هاتف المتجر';

  @override
  String get storeEmail => 'بريد المتجر';

  @override
  String get tabDetails => 'البيانات الأساسية';

  @override
  String get tabContact => 'التواصل';

  @override
  String get storeFacebook => 'فيسبوك';

  @override
  String get storeInstagram => 'إنستغرام';

  @override
  String get storeTeam => 'الفريق';

  @override
  String get save => 'حفظ';

  @override
  String get notSaved => 'غير محفوظ';

  @override
  String get savedDone => 'تم الحفظ';

  @override
  String get discardChangesTitle => 'تجاهل التعديلات؟';

  @override
  String get discardChangesMessage =>
      'لم تُحفظ تعديلاتك. هل تريد المغادرة دون حفظ؟';

  @override
  String get discardChanges => 'تجاهل';

  @override
  String get actions => 'إجراءات';

  @override
  String get disableStore => 'إيقاف المتجر';

  @override
  String get disableStoreHint => 'إخفاؤه عن الزبائن';

  @override
  String get enableStore => 'تفعيل المتجر';

  @override
  String get deleteStore => 'حذف المتجر';

  @override
  String get deleteStoreHint => 'فقط للمتاجر التي ليس لها عروض';

  @override
  String disableStoreTitle(String store) {
    return 'إيقاف $store؟';
  }

  @override
  String get disableStoreMessage =>
      'لن يرى الزبائن المتجر ولا عروضه، ولن يستطيع فريقه نشر عروض جديدة. يمكنك تفعيله مجددًا في أي وقت.';

  @override
  String disableStoreOffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تُخفى معه عروضه الجارية ($count).',
      one: 'يُخفى معه عرضه الجاري.',
    );
    return '$_temp0';
  }

  @override
  String disableStoreBookings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count حجزًا بانتظار الاستلام. تبقى صالحة، ومن لم يستلم حجزه لن يُحسب عليه.',
      few:
          '$count حجوزات بانتظار الاستلام. تبقى صالحة، ومن لم يستلم حجزه لن يُحسب عليه.',
      two: 'حجزان بانتظار الاستلام. يبقيان صالحين، ومن لم يستلم حجزه لن يُحسب عليه.',
      one: 'حجز واحد بانتظار الاستلام. يبقى صالحًا، وإن لم يستلمه الزبون فلن يُحسب عليه.',
    );
    return '$_temp0';
  }

  @override
  String deleteStoreTitle(String store) {
    return 'حذف $store؟';
  }

  @override
  String get deleteStoreMessage =>
      'سيُحذف المتجر ومنتجاته نهائيًا، ويحتفظ فريقه بحساباتهم، وتبقى فروع العلامة الأخرى.';

  @override
  String get storeDisabledDone => 'أُوقف المتجر';

  @override
  String get storeEnabledDone => 'فُعِّل المتجر';

  @override
  String get storeDeletedDone => 'حُذف المتجر';

  @override
  String get storeHasOffers =>
      'لهذا المتجر عروض، لذا لا يمكن حذفه. أوقفه بدلًا من ذلك.';

  @override
  String get placeCity => 'المدينة';

  @override
  String get cityTripoli => 'طرابلس';

  @override
  String get placeArea => 'المنطقة';

  @override
  String get placeAreaHint => 'مثلاً: حي الأندلس';

  @override
  String get placeAreaHelp =>
      'تظهر مع اسم المتجر، فتُميّز فروع العلامة الواحدة عن بعضها.';

  @override
  String get placeAddress => 'العنوان';

  @override
  String get placeLocation => 'الموقع';

  @override
  String get placeLocationHelp =>
      'الصق رابط خرائط Google، أو الإحداثيات مثل 32.8872, 13.1913';

  @override
  String get hoursNote =>
      'اكتب الأوقات مثل 08:00-23:00، ومع استراحة 08:00-13:00، 16:00-23:00. اكتب - ليوم الإغلاق، واليوم الفارغ لا يظهر للزبائن.';

  @override
  String get invalidHours =>
      'اكتب الأوقات مثل 08:00-23:00، وحتى 4 فترات في اليوم.';

  @override
  String get daySat => 'السبت';

  @override
  String get daySun => 'الأحد';

  @override
  String get dayMon => 'الاثنين';

  @override
  String get dayTue => 'الثلاثاء';

  @override
  String get dayWed => 'الأربعاء';

  @override
  String get dayThu => 'الخميس';

  @override
  String get dayFri => 'الجمعة';

  @override
  String get addLocation => 'إضافة فرع آخر';

  @override
  String get addLocationHint => 'بنفس الاسم والصور والمالكين في مكان آخر';

  @override
  String addLocationTitle(String store) {
    return 'فرع جديد لـ $store';
  }

  @override
  String get addLocationNote =>
      'الفرع متجر مستقل، يأخذ من هذا المتجر الاسم والصور والتصنيف وروابط التواصل وتعليمات الاستلام والمالكين.';

  @override
  String get addLocationButton => 'إضافة الفرع';

  @override
  String get locationPhone => 'هاتف الفرع';

  @override
  String get locationPhoneHelp => 'اتركه فارغًا ليأخذ هاتف هذا المتجر.';

  @override
  String get locationAddedDone => 'أُضيف الفرع';

  @override
  String get invalidLocation =>
      'تعذّرت قراءة موقع من هذا الرابط. الصق رابط خرائط Google أو الإحداثيات.';

  @override
  String get locationOutsideLibya => 'هذا الموقع خارج ليبيا.';

  @override
  String locationFound(String latitude, String longitude) {
    return 'الموقع: $latitude، $longitude';
  }

  @override
  String get locationUnchecked =>
      'تعذّر التحقق من الرابط. تحقق من اتصالك وحاول مجددًا.';

  @override
  String get ownerName => 'اسم صاحب المتجر';

  @override
  String get ownerPhone => 'هاتف صاحب المتجر';

  @override
  String get ownerPhoneHelp =>
      'يسجّل صاحب المتجر الدخول إلى تطبيق المتاجر بهذا الرقم.';

  @override
  String get phoneTakenByCustomer =>
      'هذا الرقم مسجّل كحساب زبون. استخدم رقماً آخر لصاحب المتجر.';

  @override
  String get categoriesFailed => 'تعذّر تحميل التصنيفات.';

  @override
  String get storeCreatedTitle => 'تم إنشاء المتجر';

  @override
  String storeCreatedMessage(String store) {
    return 'أعطِ هذه البيانات لصاحب $store. سيختار كلمة مرور خاصة به عند أول دخول.';
  }

  @override
  String get loginPhone => 'رقم الدخول';

  @override
  String get temporaryPassword => 'كلمة المرور المؤقتة';

  @override
  String get passwordShownOnce =>
      'تظهر كلمة المرور الآن فقط. انسخها قبل الإغلاق.';

  @override
  String ownerLinkedMessage(String store) {
    return 'هذا الرقم لديه حساب متجر من قبل، فأُضيف كصاحب لـ $store. يسجّل الدخول بكلمة مروره الحالية.';
  }

  @override
  String get done => 'تم';

  @override
  String get usersTitle => 'المستخدمون';

  @override
  String usersTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مستخدم',
      few: '$count مستخدمين',
      two: 'مستخدمان',
      one: 'مستخدم واحد',
      zero: 'لا مستخدمين',
    );
    return '$_temp0';
  }

  @override
  String get usersSearch => 'ابحث بالاسم أو البريد';

  @override
  String get usersEmpty => 'لا يوجد مستخدمون بعد';

  @override
  String get usersEmptyMessage => 'أضف أفراد فريقك الذين يستخدمون لوحة التحكم.';

  @override
  String get filterAdmins => 'المديرون';

  @override
  String get filterEditors => 'المحررون';

  @override
  String get roleAdmin => 'مدير';

  @override
  String get roleEditor => 'محرر';

  @override
  String get columnEmail => 'البريد الإلكتروني';

  @override
  String get columnRole => 'الدور';

  @override
  String get columnLastLogin => 'آخر دخول';

  @override
  String get neverLoggedIn => 'لم يدخل بعد';

  @override
  String get userActive => 'نشط';

  @override
  String get userDisabled => 'موقوف';

  @override
  String get addUser => 'إضافة مستخدم';

  @override
  String get addUserTitle => 'إضافة مستخدم';

  @override
  String get userName => 'الاسم';

  @override
  String get userEmail => 'البريد الإلكتروني';

  @override
  String get userEmailHelp => 'يسجّل الدخول به.';

  @override
  String get userRole => 'الدور';

  @override
  String get userRoleHelp =>
      'يستطيع المحرر الإضافة والتعديل، لكن لا يستطيع الحذف أو إدارة المستخدمين.';

  @override
  String get emailTaken => 'هذا البريد مسجّل لحساب آخر.';

  @override
  String get userCreatedTitle => 'أُضيف المستخدم';

  @override
  String userCreatedMessage(String name) {
    return 'أعطِ هذه البيانات لـ $name. سيختار كلمة مروره عند أول دخول.';
  }

  @override
  String get loginEmail => 'بريد الدخول';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordHint => 'إعطاؤه كلمة مرور مؤقتة جديدة';

  @override
  String resetPasswordTitle(String name) {
    return 'إعادة تعيين كلمة مرور $name؟';
  }

  @override
  String get resetPasswordMessage =>
      'سيحصل على كلمة مرور مؤقتة جديدة ويُسجَّل خروجه من كل الأجهزة، وتتوقف كلمة مروره الحالية.';

  @override
  String get newPasswordTitle => 'كلمة مرور جديدة';

  @override
  String newPasswordMessage(String name) {
    return 'أعطِ هذه البيانات لـ $name. سيختار كلمة مروره عند دخوله القادم.';
  }

  @override
  String get disableUser => 'إيقاف المستخدم';

  @override
  String get disableUserHint => 'تسجيل خروجه ومنعه من الدخول';

  @override
  String get enableUser => 'تفعيل المستخدم';

  @override
  String disableUserTitle(String name) {
    return 'إيقاف $name؟';
  }

  @override
  String get disableUserMessage =>
      'سيُسجَّل خروجه من كل الأجهزة ولن يستطيع الدخول حتى تفعّله مجدداً.';

  @override
  String get userDisabledDone => 'أُوقف المستخدم';

  @override
  String get userEnabledDone => 'فُعّل المستخدم';

  @override
  String get settings => 'الإعدادات';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsAppearanceHint => 'شكل لوحة التحكم على هذا الجهاز.';

  @override
  String get settingsTheme => 'السمة';

  @override
  String get settingsThemeHint => 'التلقائي يتبع إعداد جهازك الفاتح أو الداكن.';

  @override
  String get themeSystem => 'تلقائي';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageHint =>
      'لغة لوحة التحكم على هذا الجهاز. العربية تُقرأ من اليمين إلى اليسار.';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get navPlatform => 'إعدادات المنصة';

  @override
  String get platformSettingsTitle => 'إعدادات المنصة';

  @override
  String get platformOffersSection => 'العروض والحجوزات';

  @override
  String get browseRadiusLabel => 'نطاق العروض (كم)';

  @override
  String browseRadiusHint(int min, int max) {
    return 'يرى الزبون عروض المتاجر القريبة منه ضمن هذه المسافة، من $min إلى $max كم. يسري فورًا.';
  }

  @override
  String get browseRadiusEditorHint =>
      'يرى الزبون عروض المتاجر القريبة منه ضمن هذه المسافة. يغيّرها المدير فقط.';

  @override
  String get holdMinutesLabel => 'مدة الحجز للاستلام (دقائق)';

  @override
  String holdMinutesHint(int min, int max) {
    return 'كم ينتظر الحجز الزبون حتى يستلم، من $min إلى $max دقيقة، إلا إذا انتهى العرض قبلها. الحجوزات الحالية تبقى على مدتها.';
  }

  @override
  String get holdMinutesEditorHint =>
      'كم ينتظر الحجز الزبون حتى يستلم. يغيّرها المدير فقط.';

  @override
  String get platformAreasSection => 'مناطق الخدمة';

  @override
  String get serviceAreasHelp =>
      'الزبائن يتصفحون العروض من داخل هذه الدوائر فقط، والتطبيق يرسمها على الخريطة.';

  @override
  String get addServiceArea => 'إضافة منطقة';

  @override
  String get addServiceAreaTitle => 'منطقة خدمة جديدة';

  @override
  String get editServiceAreaTitle => 'تعديل منطقة الخدمة';

  @override
  String get serviceAreaNameAr => 'الاسم بالعربي';

  @override
  String get serviceAreaNameEn => 'الاسم بالإنجليزي';

  @override
  String get serviceAreaCenter => 'المركز';

  @override
  String get serviceAreaCenterHelp =>
      'من خرائط Google: اضغط على مركز المدينة وانسخ الإحداثيات.';

  @override
  String get invalidCoordinates =>
      'اكتب خط العرض ثم خط الطول، مثل 32.85, 13.18';

  @override
  String get serviceAreaRadius => 'نصف القطر (كم)';

  @override
  String serviceAreaRadiusHint(int min, int max) {
    return 'من $min إلى $max كم حول المركز.';
  }

  @override
  String get serviceAreaOn => 'مفعّلة';

  @override
  String get serviceAreaOff => 'متوقفة';

  @override
  String serviceAreasTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منطقة',
      few: '$count مناطق',
      two: 'منطقتان',
      one: 'منطقة واحدة',
      zero: 'لا مناطق',
    );
    return '$_temp0';
  }

  @override
  String get deleteServiceArea => 'حذف المنطقة';

  @override
  String deleteServiceAreaTitle(String area) {
    return 'حذف $area؟';
  }

  @override
  String get deleteServiceAreaMessage =>
      'الزبائن داخلها لن يقدروا يتصفحوا العروض. لإيقافها مؤقتًا اجعلها متوقفة بدل الحذف.';

  @override
  String get navSearches => 'عمليات البحث';

  @override
  String get searchesTitle => 'ما يبحث عنه الزبائن';

  @override
  String get searchesSearch => 'ابحث في عمليات البحث';

  @override
  String searchesTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عملية بحث',
      few: '$count عمليات بحث',
      two: 'عمليتا بحث',
      one: 'عملية بحث واحدة',
      zero: 'لا عمليات بحث',
    );
    return '$_temp0';
  }

  @override
  String get searchesEmpty => 'لا توجد عمليات بحث بعد';

  @override
  String get searchesEmptyMessage =>
      'هنا يظهر ما يبحث عنه الزبائن في التطبيق، الأكثر بحثًا أولًا.';

  @override
  String get filterNothingFound => 'لم يجد شيئًا';

  @override
  String get filterFound => 'وجد عروضًا';

  @override
  String get columnSearch => 'البحث';

  @override
  String get columnSearchCount => 'مرات البحث';

  @override
  String get columnFound => 'آخر ما وجده';

  @override
  String get columnLastSearched => 'آخر بحث';

  @override
  String get foundNothing => 'لا شيء';

  @override
  String foundOffers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عرضًا',
      few: '$count عروض',
      two: 'عرضان',
      one: 'عرض واحد',
      zero: 'لا عروض',
    );
    return '$_temp0';
  }

  @override
  String get navSystem => 'النظام';

  @override
  String get systemTitle => 'النظام';

  @override
  String get systemTabOverview => 'نظرة عامة';

  @override
  String get systemTabTraffic => 'الطلبات';

  @override
  String get systemTabErrors => 'الأخطاء';

  @override
  String get systemTabJobs => 'المهام';

  @override
  String get systemTabDatabase => 'قاعدة البيانات';

  @override
  String get systemRedis => 'Redis (الذاكرة المشتركة)';

  @override
  String get systemInstances => 'النسخ العاملة';

  @override
  String get systemCheckedAt => 'آخر فحص';

  @override
  String systemCheckedAtValue(String time) {
    return '$time · كل 15 ثانية';
  }

  @override
  String get systemAllGood => 'كل شيء يعمل';

  @override
  String get systemNeedsAttention => 'هناك ما يحتاج إلى نظرة';

  @override
  String get healthUp => 'يعمل';

  @override
  String get healthDown => 'متوقف';

  @override
  String get healthOff => 'غير مُعَدّ';

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
    return '$minutes د';
  }

  @override
  String uptimeHours(int hours, int minutes) {
    return '$hours س $minutes د';
  }

  @override
  String uptimeDays(int days, int hours) {
    return '$days ي $hours س';
  }

  @override
  String get figureRequestsPerMinute => 'طلب في الدقيقة';

  @override
  String get figureServerErrors => 'أخطاء الخادم';

  @override
  String figureServerErrorsHint(int count) {
    return '$count في 5 دقائق';
  }

  @override
  String get figureLatency => 'زمن الاستجابة (p95)';

  @override
  String get figureLast5Minutes => 'آخر 5 دقائق';

  @override
  String get figureErrorKinds => 'أنواع الأخطاء';

  @override
  String get figureLastDay => 'آخر 24 ساعة';

  @override
  String figureFailingJobs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مهمة فاشلة',
      few: '$count مهام فاشلة',
      two: 'مهمتان فاشلتان',
      one: 'مهمة فاشلة',
      zero: 'لا مهمة فاشلة',
    );
    return '$_temp0';
  }

  @override
  String get instanceThisOne => 'أجابت';

  @override
  String instanceSubtitle(String version, String uptime) {
    return 'الإصدار $version · تعمل منذ $uptime';
  }

  @override
  String get instanceMemory => 'الذاكرة';

  @override
  String instanceMemoryValue(String total, String heap) {
    return '$total ($heap يستخدمها JavaScript)';
  }

  @override
  String get instanceCpu => 'المعالج';

  @override
  String get instanceEventLoop => 'تأخر حلقة الأحداث';

  @override
  String get instanceConnections => 'اتصالات قاعدة البيانات';

  @override
  String instanceConnectionsValue(int open, int idle, int waiting, int max) {
    return '$open مفتوح · $idle خامل · $waiting بانتظار · حتى $max';
  }

  @override
  String get instanceRequests => 'طلب في الدقيقة';

  @override
  String get instanceStarted => 'بدأت';

  @override
  String get instanceReported => 'آخر تقرير';

  @override
  String trafficWindow(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String trafficSummary(int requests, int errors, int minutes) {
    return '$requests طلب و$errors خطأ في الخادم خلال آخر $minutes دقيقة';
  }

  @override
  String trafficMinutesAgo(int minutes) {
    return 'قبل $minutes دقيقة';
  }

  @override
  String get trafficNow => 'الآن';

  @override
  String trafficBar(String time, int requests, int errors) {
    return '$time · $requests طلب · $errors خطأ';
  }

  @override
  String get trafficRoutes => 'المسارات، الأكثر طلبًا أولًا';

  @override
  String trafficRouteLatency(String p50, String p95, String p99) {
    return 'p50 $p50 · p95 $p95 · p99 $p99';
  }

  @override
  String trafficRouteErrors(String latency, int errors, int refused) {
    return '$latency · $errors خطأ في الخادم · $refused مرفوض';
  }

  @override
  String get trafficEmpty => 'لا طلبات بعد';

  @override
  String get trafficEmptyMessage =>
      'تظهر الطلبات هنا حين تستخدم التطبيقات الخادم.';

  @override
  String get errorsEmpty => 'لا أخطاء في الخادم';

  @override
  String get errorsEmptyMessage =>
      'تظهر هنا أخطاء آخر 24 ساعة، والخطأ نفسه على المسار نفسه مرة واحدة.';

  @override
  String errorTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرة',
      few: '$count مرات',
      two: 'مرتان',
      one: 'مرة واحدة',
    );
    return '$_temp0';
  }

  @override
  String errorSubtitle(String route, String times, String when) {
    return '$route · $times · آخرها $when';
  }

  @override
  String get errorRequestId => 'رقم آخر طلب (للبحث عنه في السجلات)';

  @override
  String get errorFirstSeen => 'أول مرة';

  @override
  String get errorLastSeen => 'آخر مرة';

  @override
  String get errorStack => 'أين حدث';

  @override
  String get jobRunNow => 'شغّلها الآن';

  @override
  String jobRan(String duration) {
    return 'انتهت في $duration';
  }

  @override
  String get jobRanFailed => 'فشلت المهمة: آخر خطأ يقول السبب.';

  @override
  String get jobAlreadyRunning => 'هذه المهمة تعمل الآن.';

  @override
  String get jobSucceeded => 'نجحت';

  @override
  String get jobFailed => 'فشلت';

  @override
  String get jobRunning => 'تعمل';

  @override
  String get jobNeverRun => 'لم تعمل بعد';

  @override
  String get jobSchedule => 'الموعد (cron)';

  @override
  String get jobByHand => 'يدويًا فقط';

  @override
  String get jobNextRun => 'التشغيل القادم';

  @override
  String get jobLastRun => 'آخر تشغيل';

  @override
  String jobLastRunValue(String when, String duration) {
    return '$when · $duration';
  }

  @override
  String get jobLastResult => 'ما فعلته';

  @override
  String get jobRuns => 'مرات التشغيل';

  @override
  String jobRunsValue(int runs, int failures) {
    return '$runs ($failures فشلت)';
  }

  @override
  String get jobLastError => 'آخر خطأ';

  @override
  String get jobsEmpty => 'لا مهام';

  @override
  String get dbSize => 'الحجم';

  @override
  String get dbConnections => 'الاتصالات';

  @override
  String dbConnectionsHint(int active, int max) {
    return '$active نشط · حتى $max';
  }

  @override
  String get dbCacheHit => 'قراءة من الذاكرة';

  @override
  String get dbCacheHitHint => 'تحت 99% تحتاج ذاكرة أكثر';

  @override
  String get dbWaiting => 'بانتظار';

  @override
  String dbWaitingHint(int locks, int idle) {
    return '$locks على أقفال · $idle خاملة في معاملة';
  }

  @override
  String dbVersion(String version) {
    return 'Postgres $version';
  }

  @override
  String get dbStatementsOff => 'توقيت الاستعلامات متوقف';

  @override
  String get dbStatementsOffMessage =>
      'فعّل pg_stat_statements في Postgres لرؤية الاستعلامات الأكثر استهلاكًا للوقت.';

  @override
  String get dbRunning => 'تعمل منذ أكثر من ثانية';

  @override
  String dbRunningWaiting(String duration, String what) {
    return '$duration · بانتظار $what';
  }

  @override
  String get dbSlowest => 'الأكثر استهلاكًا للوقت';

  @override
  String dbQueryStats(int calls, String mean, String total) {
    return '$calls مرة · $mean للمرة · $total إجمالًا';
  }

  @override
  String get dbTables => 'الجداول، الأكبر أولًا';

  @override
  String dbTableRows(int rows, int dead) {
    return '$rows صف · $dead بانتظار التنظيف';
  }

  @override
  String get systemStatus => 'الحالة';

  @override
  String get jobExpireClaims =>
      'تُنهي الحجوزات التي لم تُستلم: تعود القطع للبيع، ويُحسب على الزبون تخلّف، وكل ثالث يمنعه من الحجز 7 أيام. وتُنهي العروض التي انتهى وقتها.';

  @override
  String get jobExpireClaimsBacklog => 'حجوزات تجاوزت وقتها';

  @override
  String get jobCleanTokens =>
      'تحذف رموز الدخول المنتهية، أو المستعملة أو الملغاة منذ أكثر من 7 أيام.';

  @override
  String get jobCleanTokensBacklog => 'رموز للحذف';

  @override
  String get jobCleanSearchTerms =>
      'تحذف عمليات البحث التي تكررت أقل من 3 مرات ولم يُبحث عنها منذ 90 يومًا.';

  @override
  String get jobCleanSearchTermsBacklog => 'عمليات بحث للحذف';

  @override
  String get navActivity => 'سجل النشاط';

  @override
  String get activityTitle => 'من غيّر ماذا';

  @override
  String get activitySearch => 'ابحث بالاسم';

  @override
  String activityTotal(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تغيير',
      few: '$count تغييرات',
      two: 'تغييران',
      one: 'تغيير واحد',
      zero: 'لا تغييرات',
    );
    return '$_temp0';
  }

  @override
  String get activityEmpty => 'لا توجد تغييرات بعد';

  @override
  String get activityEmptyMessage =>
      'يظهر هنا كل تغيير في لوحة التحكم: من قام به ومتى.';

  @override
  String get activityAreaServiceAreas => 'مناطق الخدمة';

  @override
  String get activityAreaSettings => 'الإعدادات';

  @override
  String get activityAreaJobs => 'المهام';

  @override
  String get columnWhen => 'متى';

  @override
  String get columnWho => 'من';

  @override
  String get columnWhat => 'ماذا';

  @override
  String get columnItem => 'العنصر';

  @override
  String get columnFields => 'الحقول';

  @override
  String get activityRemovedAccount => 'حساب محذوف';

  @override
  String get activityRequestId => 'رقم الطلب (للبحث عنه في السجلات)';

  @override
  String get activitySent => 'ما تم إرساله';

  @override
  String get activityNothingSent => 'لم يُرسل شيء';

  @override
  String get activityStoreCreate => 'إضافة متجر';

  @override
  String get activityStoreUpdate => 'تعديل متجر';

  @override
  String get activityStoreDelete => 'حذف متجر';

  @override
  String get activityStoreAddLocation => 'إضافة فرع';

  @override
  String get activityStoreAddMember => 'إضافة شخص إلى متجر';

  @override
  String get activityStoreRemoveMember => 'إزالة شخص من متجر';

  @override
  String get activityStoreSetImage => 'تغيير صورة متجر';

  @override
  String get activityStoreRemoveImage => 'حذف صورة متجر';

  @override
  String get activityUserCreate => 'إضافة عضو إلى الفريق';

  @override
  String get activityUserUpdate => 'تعديل حساب';

  @override
  String get activityUserDisable => 'إيقاف حساب';

  @override
  String get activityUserEnable => 'تفعيل حساب';

  @override
  String get activityUserResetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get activityCategoryCreate => 'إضافة تصنيف';

  @override
  String get activityCategoryUpdate => 'تعديل تصنيف';

  @override
  String get activityServiceAreaCreate => 'إضافة منطقة خدمة';

  @override
  String get activityServiceAreaUpdate => 'تعديل منطقة خدمة';

  @override
  String get activityServiceAreaDelete => 'حذف منطقة خدمة';

  @override
  String get activitySettingsUpdate => 'تغيير إعدادات المنصة';

  @override
  String get activityOfferRemove => 'إيقاف عرض';

  @override
  String get activityJobRun => 'تشغيل مهمة يدويًا';

  @override
  String get storePhoneHelp => 'يتصل به الزبائن بخصوص الاستلام.';

  @override
  String get goLiveTitle => 'قبل ظهوره للزبائن';

  @override
  String get goLiveNote =>
      'يظهر المتجر للزبائن بعد تفعيله، ولا يُفعَّل قبل أن يكتمل ما يلي.';

  @override
  String get goLiveLogo => 'الشعار';

  @override
  String get goLiveLogoWhere =>
      'من تبويب الصور، أو يضيفه صاحب المتجر من تطبيق المتاجر.';

  @override
  String get goLivePickupWhere =>
      'في تبويب البيانات الأساسية، أو يكتبها صاحب المتجر.';

  @override
  String get goLiveHoursWhere => 'في تبويب المكان، أو يضيفها صاحب المتجر.';

  @override
  String get goLiveDone => 'تم';

  @override
  String get goLiveMissing => 'ناقص';

  @override
  String get tabPhotos => 'الصور';

  @override
  String get storePhotosNote =>
      'يرى الزبائن الشعار بجانب اسم المتجر، والغلاف أعلى صفحته. اضغط على أيٍّ منهما لتختار صورة من جهازك، وتُرفع فوراً.';

  @override
  String get storeLogo => 'الشعار';

  @override
  String get storeCover => 'صورة الغلاف';

  @override
  String get addLogo => 'أضف الشعار';

  @override
  String get addCover => 'أضف صورة غلاف';

  @override
  String get coverHint => 'واجهة المحل أو ما يبيعه';

  @override
  String get removeLogo => 'احذف الشعار';

  @override
  String get removeCover => 'احذف الغلاف';

  @override
  String removeLogoTitle(String store) {
    return 'حذف شعار $store؟';
  }

  @override
  String removeCoverTitle(String store) {
    return 'حذف صورة غلاف $store؟';
  }

  @override
  String get removePhotoMessage =>
      'لن يراها الزبائن بعد الآن، ويمكنك إضافة غيرها متى شئت.';

  @override
  String get photoRemovedDone => 'حُذفت الصورة';

  @override
  String get liveStoreKeepsLogo =>
      'المتجر الظاهر للزبائن يبقى بشعاره: يمكن تغييره لا حذفه.';

  @override
  String get photoTooLarge =>
      'حجم الصورة أكبر من 1 ميغابايت. اختر صورة أصغر، أو بصيغة JPEG.';

  @override
  String enableStoreNeeds(String items) {
    return 'ينقصه: $items';
  }

  @override
  String get storeNotReady =>
      'المتجر الظاهر للزبائن يحتاج شعاراً وتعليمات استلام وأوقات عمل.';

  @override
  String get storeReadyToGoLive => 'جاهز للتفعيل';

  @override
  String get storeNotReadyBadge => 'غير جاهز';

  @override
  String get storeHiddenTitle => 'لا يراه الزبائن بعد';

  @override
  String get storeHiddenMessage =>
      'فعّله من صفحته بعد أن يكون له شعار وتعليمات استلام وأوقات عمل. يستطيع صاحبه إضافتها من تطبيق المتاجر.';
}
