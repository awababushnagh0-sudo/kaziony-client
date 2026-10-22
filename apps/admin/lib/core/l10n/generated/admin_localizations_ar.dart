// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'admin_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AdminLocalizationsAr extends AdminLocalizations {
  AdminLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'إدارة العروض';

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
  String get storesSearch => 'ابحث بالاسم';

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
  String get columnBranches => 'الفروع';

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
  String get sectionBranch => 'الفرع الأول';

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
  String get storeDescription => 'الوصف';

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
  String deleteStoreTitle(String store) {
    return 'حذف $store؟';
  }

  @override
  String get deleteStoreMessage =>
      'سيُحذف المتجر وفروعه ومنتجاته نهائيًا، ويحتفظ فريقه بحساباتهم.';

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
  String get branchName => 'اسم الفرع';

  @override
  String get branchNameHint => 'مثلاً: حي الأندلس';

  @override
  String get branchCity => 'المدينة';

  @override
  String get cityTripoli => 'طرابلس';

  @override
  String get branchArea => 'المنطقة';

  @override
  String get branchAddress => 'العنوان';

  @override
  String get branchLocation => 'الموقع';

  @override
  String get branchLocationHelp =>
      'الصق رابط خرائط Google، أو الإحداثيات مثل 32.8872, 13.1913';

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
}
