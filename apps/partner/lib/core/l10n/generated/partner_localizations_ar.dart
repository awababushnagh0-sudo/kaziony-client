// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'partner_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class PartnerLocalizationsAr extends PartnerLocalizations {
  PartnerLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get pickupInstructionsLabel => 'تعليمات الاستلام';

  @override
  String get pickupInstructionsHint =>
      'مثال: اعرض رمزك عند الكاشير قرب الباب، وأحضر كيسًا.';

  @override
  String get pickupInstructionsHelper =>
      'يراها الزبائن في كل عرض: أين يتوجهون في المتجر وماذا يُحضرون.';

  @override
  String get ratingLabel => 'التقييم';

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
  String get appTitle => 'كزيوني للمتاجر';

  @override
  String get loginTitle => 'أهلًا بك في متجرك';

  @override
  String get loginSubtitle =>
      'ادخل برقم الهاتف وكلمة المرور اللي عطاهملك فريقنا.';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'دخول';

  @override
  String get loginJoinHint => 'محلك مش في كزيوني؟';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get termsAgreement => 'بتسجيل الدخول فأنت توافق على';

  @override
  String get contactMessage =>
      'نسيت كلمة المرور، أو تريد إضافة متجرك، أو تحتاج مساعدة؟ فريقنا هنا لمساعدتك.';

  @override
  String get callUs => 'اتصال';

  @override
  String get whatsappUs => 'واتساب';

  @override
  String get supportHours => 'أوقات الرد';

  @override
  String get linkNotOpened => 'تعذّر فتحه على هذا الهاتف.';

  @override
  String get wrongCredentials => 'رقم الهاتف أو كلمة المرور غير صحيحة.';

  @override
  String get accountDisabled => 'هذا الحساب موقوف. تواصل معنا.';

  @override
  String get sessionExpired => 'انتهت الجلسة. سجّل الدخول مرة أخرى.';

  @override
  String get notStoreAccount => 'هذا التطبيق لحسابات المتاجر فقط.';

  @override
  String get changePasswordTitle => 'اختر كلمة مرور جديدة';

  @override
  String get changePasswordSubtitle =>
      'أنت تستخدم كلمة مرور مؤقتة. اختر كلمة مرورك للمتابعة.';

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
  String get logoutTitle => 'تسجيل الخروج؟';

  @override
  String get logoutMessage =>
      'ستحتاج رقم هاتفك وكلمة المرور لتسجيل الدخول مرة أخرى.';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get profileTitle => 'حسابي';

  @override
  String get chooseStoreTitle => 'اختر المتجر';

  @override
  String get chooseStoreSubtitle =>
      'تعمل في أكثر من متجر. يمكنك التبديل لاحقًا من حسابك.';

  @override
  String get ownerRole => 'مالك';

  @override
  String get staffRole => 'موظف';

  @override
  String get switchStore => 'تبديل المتجر';

  @override
  String get noStoreTitle => 'لا يوجد متجر بعد';

  @override
  String get noStoreMessage =>
      'هذا الحساب غير مرتبط بأي متجر. تواصل مع فريقنا لإعداده.';

  @override
  String get storeInfoTitle => 'معلومات المتجر';

  @override
  String get storeLogo => 'الشعار';

  @override
  String get storeCover => 'صورة الغلاف';

  @override
  String get addLogo => 'أضف شعارك';

  @override
  String get addCover => 'أضف صورة غلاف';

  @override
  String get coverHint => 'واجهة محلك أو ما تبيعه';

  @override
  String get storeImagesHint =>
      'يرى الزبائن شعارك بجانب اسمك، وصورة الغلاف أعلى صفحة متجرك.';

  @override
  String get storeInfoHint => 'يرى الزبائن هذه المعلومات في صفحة متجرك.';

  @override
  String get liveStoreNeedsPickupInstructions =>
      'متجرك ظاهر للزبائن، فلا يمكن ترك تعليمات الاستلام فارغة.';

  @override
  String get storeNameLabel => 'اسم المتجر';

  @override
  String get storeNameHint =>
      'يحدد فريقنا اسم المتجر وفئته. لتغييرهما تواصل معنا.';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get discardChangesTitle => 'تجاهل التعديلات؟';

  @override
  String get discardChangesMessage =>
      'لم تُحفظ تعديلاتك. هل تريد المغادرة دون حفظ؟';

  @override
  String get discardChanges => 'تجاهل';

  @override
  String get teamTitle => 'الفريق';

  @override
  String get locationTitle => 'الموقع وأوقات العمل';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get areaLabel => 'المنطقة';

  @override
  String get addressLabel => 'العنوان';

  @override
  String get openInMaps => 'افتح في الخرائط';

  @override
  String get openingHoursTitle => 'أوقات العمل';

  @override
  String get openingHoursHint =>
      'اضغط على يوم لتغيير أوقاته. حدد أوقات كل الأيام، حتى أيام الإغلاق.';

  @override
  String get liveStoreNeedsOpeningHours =>
      'متجرك ظاهر للزبائن، فيجب أن تحدد أوقات كل الأيام، ويومًا مفتوحًا على الأقل.';

  @override
  String get locationTeamHint =>
      'يغيّر فريقنا اسم المتجر وموقعه، ويضيف الفروع الجديدة.';

  @override
  String get requestChange => 'اطلب إضافة';

  @override
  String requestPlaceMessage(String store) {
    return 'مرحباً، أريد إضافة فرع جديد أو تعديل بيانات متجر: $store';
  }

  @override
  String requestStaffMessage(String store) {
    return 'مرحباً، أريد إضافة أو إزالة موظف في متجر: $store';
  }

  @override
  String get openDay => 'مفتوح';

  @override
  String get closedAllDay => 'مغلق';

  @override
  String shiftHours(String opens, String closes) {
    return '$opens – $closes';
  }

  @override
  String get opensAt => 'يفتح';

  @override
  String get closesAt => 'يغلق';

  @override
  String get afterBreak => 'بعد الاستراحة';

  @override
  String get addShift => 'أضف فترة بعد استراحة';

  @override
  String get removeShift => 'احذف هذه الفترة';

  @override
  String get sameEveryDay => 'نفس الأوقات لكل الأيام';

  @override
  String get done => 'تم';

  @override
  String todayAt(String store) {
    return 'اليوم في $store';
  }

  @override
  String get yourStoreSection => 'متجرك';

  @override
  String get teamHint => 'لإضافة شخص أو إزالته، تواصل مع فريقنا.';

  @override
  String get accountSection => 'حسابك';

  @override
  String get changePasswordAction => 'تغيير كلمة المرور';

  @override
  String get appSection => 'التطبيق';

  @override
  String get helpSection => 'المساعدة';

  @override
  String get aboutTitle => 'عن التطبيق';

  @override
  String get aboutText =>
      'انشر عروضًا محدودة من منتجاتك في ثوانٍ، وسلّمها عند الكاشير برمز الاستلام.';

  @override
  String get termsTitle => 'الشروط والأحكام';

  @override
  String get termsSoonTitle => 'قريبًا';

  @override
  String get termsSoonMessage =>
      'ستكون الشروط والأحكام هنا قبل أن يُفتح التطبيق للجميع.';

  @override
  String get versionLabel => 'الإصدار';

  @override
  String get categoryLabel => 'الفئة';

  @override
  String get descriptionLabel => 'الوصف';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get facebookLabel => 'فيسبوك';

  @override
  String get instagramLabel => 'إنستغرام';

  @override
  String get notSet => 'غير محدد';

  @override
  String get edit => 'تعديل';

  @override
  String get save => 'حفظ';

  @override
  String get saved => 'تم الحفظ.';

  @override
  String get inactive => 'متوقف';

  @override
  String get cityTripoli => 'طرابلس';

  @override
  String get oldPasswordLabel => 'كلمة المرور الحالية';

  @override
  String get wrongOldPassword => 'كلمة المرور الحالية غير صحيحة.';

  @override
  String get productsTitle => 'المنتجات';

  @override
  String get addProduct => 'إضافة منتج';

  @override
  String get newProductTitle => 'منتج جديد';

  @override
  String get editProductTitle => 'تعديل المنتج';

  @override
  String get searchProducts => 'ابحث في المنتجات';

  @override
  String get currentProducts => 'الحالية';

  @override
  String get archivedProducts => 'المؤرشفة';

  @override
  String get productAddPhoto => 'أضف صورة';

  @override
  String get noProductsTitle => 'لا توجد منتجات بعد';

  @override
  String get noProductsMessage => 'أضف ما تبيعه، ثم انشر عروضك منه في ثوانٍ.';

  @override
  String get noProductsMatch => 'لا توجد منتجات مطابقة لبحثك.';

  @override
  String get noArchivedProducts => 'لا توجد منتجات مؤرشفة.';

  @override
  String get productTitleLabel => 'الاسم';

  @override
  String get regularPriceLabel => 'السعر العادي';

  @override
  String get regularPriceHelper =>
      'سعره في المحل كل يوم. سعر العرض يكون أقل منه.';

  @override
  String get archiveProduct => 'أرشفة';

  @override
  String get productPhotoTipTitle => 'أضف صورة';

  @override
  String get productPhotoTipMessage =>
      'يراها الزبائن أولاً في كل عرض من هذا المنتج.';

  @override
  String get noDescription => 'لا يوجد وصف بعد.';

  @override
  String get add => 'إضافة';

  @override
  String get productDetailsTitle => 'التفاصيل';

  @override
  String get productAddedOn => 'تاريخ الإضافة';

  @override
  String get productEditedOn => 'آخر تعديل';

  @override
  String get archiveProductHint => 'يُخفى من منتجاتك، وتبقى عروضه السابقة.';

  @override
  String get productBasicsSection => 'ما الذي تبيعه';

  @override
  String get productBasicsNote => 'يرى الزبائن اسمه ووصفه في كل عرض.';

  @override
  String get priceSection => 'السعر';

  @override
  String get productTitleHint => 'مثلاً: كرواسون بالزبدة';

  @override
  String get descriptionHint => 'مكوناته، حجمه، وطريقة تحضيره';

  @override
  String get archivedStatus => 'مؤرشف';

  @override
  String get restoreProduct => 'استعادة';

  @override
  String get productArchived => 'تمت الأرشفة.';

  @override
  String get productRestored => 'تمت الاستعادة.';

  @override
  String get productSavedPhotoFailed =>
      'تم الحفظ. لم تُرفع الصورة: اضغط عليها لإعادة المحاولة.';

  @override
  String get offersTitle => 'العروض';

  @override
  String get postOffer => 'نشر عرض';

  @override
  String get noOffersTitle => 'لا توجد عروض بعد';

  @override
  String get noOffersMessage =>
      'انشر عرضًا من أحد منتجاتك، ويراه الزبائن القريبون فورًا.';

  @override
  String get noOffersHere => 'لا توجد عروض هنا.';

  @override
  String get activeOffers => 'الحالية';

  @override
  String get endedOffers => 'المنتهية';

  @override
  String get liveNowSection => 'معروضة الآن';

  @override
  String get comingUpSection => 'قادمة';

  @override
  String get pausedSection => 'موقوفة';

  @override
  String figureLeftOf(int total) {
    return 'باقي من $total';
  }

  @override
  String get figureSoldOut => 'نفدت';

  @override
  String figureAllOf(int total) {
    return 'كل الـ$total';
  }

  @override
  String get offerLive => 'متاح';

  @override
  String get offerScheduled => 'مجدول';

  @override
  String get offerSoldOut => 'نفدت الكمية';

  @override
  String get offerPaused => 'متوقف مؤقتًا';

  @override
  String get offerEnded => 'انتهى';

  @override
  String get offerRemoved => 'أزاله فريقنا';

  @override
  String get noLimit => 'بدون حد';

  @override
  String until(String date) {
    return 'حتى $date';
  }

  @override
  String get chooseProductTitle => 'اختر منتجًا';

  @override
  String get noProductsForOffer =>
      'انشر شيئًا جديدًا، ويُحفظ هنا للمرة القادمة.';

  @override
  String get newOfferTitle => 'عرض جديد';

  @override
  String get startOfferTitle => 'على ماذا العرض؟';

  @override
  String get fromMyProducts => 'من منتجاتي';

  @override
  String get fromMyProductsHint => 'منتج حفظته من قبل';

  @override
  String get somethingNew => 'شيء جديد';

  @override
  String get somethingNewHint => 'أضف صورته وسعره وانشره الآن';

  @override
  String get offerPhotoHint => 'اختيارية، لكن العروض بالصور تُحجز أكثر';

  @override
  String get quickProductNote => 'يُحفظ في منتجاتك';

  @override
  String get offerPostedPhotoFailed =>
      'نُشر العرض. لم تُرفع الصورة: أضفها من صفحة المنتج.';

  @override
  String regularPriceIs(String price) {
    return 'السعر العادي $price';
  }

  @override
  String get offerPriceLabel => 'سعر العرض';

  @override
  String offerPriceTooHigh(String price) {
    return 'يجب أن يكون أقل من السعر العادي ($price)';
  }

  @override
  String get offerTypeLabel => 'الكمية';

  @override
  String get limitedType => 'عدد محدد';

  @override
  String get unlimitedType => 'بدون حد';

  @override
  String get quantityLabel => 'عدد القطع';

  @override
  String get perCustomerLabel => 'لكل زبون';

  @override
  String get endsLabel => 'ينتهي';

  @override
  String get endsTonight => 'الليلة';

  @override
  String get endsTomorrow => 'ليلة الغد';

  @override
  String get endsIn3Days => 'بعد 3 أيام';

  @override
  String get endsInAWeek => 'بعد أسبوع';

  @override
  String get endsInPast => 'اختر وقتًا لم يأتِ بعد.';

  @override
  String get endsTooLate => 'مدة العرض 30 يومًا كحد أقصى.';

  @override
  String get offerClosedThroughTitle => 'المتجر مغلق طوال وقت العرض';

  @override
  String offerClosedThroughMessage(String opens) {
    return 'يفتح $opens، بعد نهاية العرض، فلن يستلمه أحد. اجعله ينتهي لاحقًا، أو راجع أوقات العمل.';
  }

  @override
  String get offerOutsideHoursTitle => 'جزء من وقت العرض خارج أوقات العمل';

  @override
  String offerOpensLater(String opens) {
    return 'المتجر مغلق الآن، ويستلم الزبائن عندما يفتح $opens.';
  }

  @override
  String offerClosesBeforeEnd(String closes) {
    return 'يغلق المتجر $closes قبل نهاية العرض، ولا استلام بعد ذلك.';
  }

  @override
  String get offerPosted => 'تم نشر العرض.';

  @override
  String holdValue(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get startsLabel => 'يبدأ';

  @override
  String get pauseOffer => 'إيقاف مؤقت';

  @override
  String get resumeOffer => 'استئناف';

  @override
  String get endOffer => 'إنهاء العرض';

  @override
  String get endOfferTitle => 'إنهاء هذا العرض؟';

  @override
  String get endOfferMessage =>
      'لن يتمكن الزبائن من حجزه بعد الآن. الحجوزات الحالية يمكن استلامها.';

  @override
  String get offerPausedDone => 'تم الإيقاف المؤقت: لا يراه الزبائن الآن.';

  @override
  String get offerResumed => 'أصبح العرض ظاهرًا للزبائن من جديد.';

  @override
  String get offerEndedDone => 'تم إنهاء العرض.';

  @override
  String get repostOffer => 'نشره مرة أخرى';

  @override
  String get editOfferTitle => 'تعديل العرض';

  @override
  String get offerTitleLabel => 'العنوان';

  @override
  String get holdTitle => 'مدة الحجز';

  @override
  String get scanTitle => 'مسح';

  @override
  String get scanHint => 'وجّه الكاميرا نحو رمز الزبون';

  @override
  String get typeCode => 'اكتب الرمز';

  @override
  String get codeLabel => 'الرمز';

  @override
  String get tapToCopy => 'اضغط للنسخ';

  @override
  String get codeCopied => 'نُسخ الرمز';

  @override
  String get codeHelper => 'الأحرف والأرقام الثمانية تحت رمز QR عند الزبون.';

  @override
  String get checkCode => 'تحقق من الرمز';

  @override
  String get notAClaimCode => 'رمز QR هذا ليس حجزًا.';

  @override
  String get cameraOffScanMessage =>
      'اسمح للتطبيق باستخدام الكاميرا من الإعدادات لمسح الرموز، أو اكتب الرمز.';

  @override
  String get cameraFailedTitle => 'لم تفتح الكاميرا';

  @override
  String get cameraFailedMessage => 'اكتب رمز الزبون بدلًا من ذلك.';

  @override
  String get pickupsTitle => 'في الطريق';

  @override
  String get noPickupsTitle => 'لا أحد في الطريق';

  @override
  String get noPickupsMessage => 'تظهر الحجوزات هنا حتى تُستلم.';

  @override
  String get someCustomer => 'زبون';

  @override
  String get claimTitle => 'الاستلام';

  @override
  String get toCollect => 'المبلغ المطلوب';

  @override
  String get customerLabel => 'الزبون';

  @override
  String get heldUntil => 'محجوز حتى';

  @override
  String get pickedUpAtLabel => 'وقت الاستلام';

  @override
  String get confirmPickup => 'تأكيد الاستلام';

  @override
  String problemRedeemedAt(String time) {
    return 'استُلم بالفعل: $time.';
  }

  @override
  String get problemRedeemed => 'استُلم بالفعل.';

  @override
  String get problemCancelled => 'ألغى الزبون هذا الحجز.';

  @override
  String get problemExpired => 'انتهت مدة هذا الحجز.';

  @override
  String get problemOther => 'لا يمكن استلام هذا الرمز.';

  @override
  String get claimNotFound => 'لا يوجد حجز بهذا الرمز في متجرك.';

  @override
  String get pickedUpTitle => 'تم الاستلام';

  @override
  String get nextCustomer => 'الزبون التالي';

  @override
  String get refresh => 'تحديث';

  @override
  String get todayTitle => 'اليوم';

  @override
  String get statPickedUp => 'تم الاستلام';

  @override
  String get statNotPickedUp => 'لم يُستلم';

  @override
  String get statLiveOffers => 'عروض متاحة';

  @override
  String soonestIn(String time) {
    return 'أقربهم بعد $time';
  }

  @override
  String ofClaimsToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'من $count حجز اليوم',
      many: 'من $count حجزًا اليوم',
      few: 'من $count حجوزات اليوم',
      two: 'من حجزين اليوم',
      one: 'من حجز واحد اليوم',
    );
    return '$_temp0';
  }

  @override
  String almostGone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تكاد تنفد',
      two: 'اثنان يكادان ينفدان',
      one: 'واحد يكاد ينفد',
    );
    return '$_temp0';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes د';
  }

  @override
  String hoursShort(int hours) {
    return '$hours س';
  }

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get yourLiveOffers => 'عروضك المتاحة';

  @override
  String get liveOffersTitle => 'العروض المتاحة';

  @override
  String get nobodyOnTheWay => 'لا أحد في الطريق الآن.';

  @override
  String get noLiveOffers => 'لا توجد عروض متاحة الآن.';

  @override
  String get quietDayTitle => 'يوم هادئ حتى الآن';

  @override
  String get quietDayOwnerMessage =>
      'انشر عرضًا، وسيظهر هنا الزبائن الذين يحجزونه وهم في الطريق إليك.';

  @override
  String get quietDayStaffMessage =>
      'عندما ينشر متجرك عرضًا، سيظهر هنا الزبائن الذين يحجزونه.';

  @override
  String get storeNotLiveTitle => 'متجرك لا يظهر للزبائن بعد';

  @override
  String get storeNotLiveOwnerMessage =>
      'أضف ما يلي، وبعدها يفعّله فريقنا ليراه الزبائن.';

  @override
  String get storeNotLiveStaffMessage =>
      'يحتاج مالك المتجر إلى إضافة ما يلي أولًا.';

  @override
  String get storeReadyTitle => 'متجرك جاهز';

  @override
  String get storeReadyMessage => 'سيفعّله فريقنا قريبًا ليراه الزبائن.';

  @override
  String get messageUsOnWhatsApp => 'راسلنا على واتساب';

  @override
  String turnOnStoreMessage(String store) {
    return 'مرحباً، متجري جاهز. أرجو تفعيله ليراه الزبائن: $store';
  }

  @override
  String get storeOffTitle => 'متجرك متوقف عن الظهور للزبائن';

  @override
  String get storeOffMessage =>
      'لا يرى الزبائن متجرك ولا عروضه الآن. الحجوزات التي تمت يمكن استلامها.';

  @override
  String askWhyStoreOffMessage(String store) {
    return 'مرحبًا، متجري متوقف عن الظهور للزبائن. هل يمكنكم إخباري بالسبب؟ $store';
  }

  @override
  String get storeNotLiveCantPost =>
      'متجرك لا يظهر للزبائن بعد، لذا لا يمكنه نشر العروض. تجد في الرئيسية ما تبقّى.';

  @override
  String get soonestFirst => 'أقرب انتهاء أولًا';

  @override
  String get pickupsEndNote => 'تبقى الحجوزات هنا حتى تُستلم أو تنتهي مدتها.';

  @override
  String get collectFromCustomer => 'استلم من الزبون';

  @override
  String piecesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قطعة',
      few: '$count قطع',
      two: 'قطعتان',
      one: 'قطعة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get claimReserved => 'محجوز';

  @override
  String get claimRedeemed => 'تم الاستلام';

  @override
  String get claimExpired => 'انتهى';

  @override
  String get claimCancelled => 'ملغي';

  @override
  String heldUntilLeft(String time, String left) {
    return '$time (باقي $left)';
  }

  @override
  String get problemRedeemedHint =>
      'لا تسلّم الطلب مرة أخرى. إذا قال الزبون إنه لم يستلمه، تحقّق مع زميلك.';

  @override
  String get problemCancelledHint =>
      'لا تسلّم الطلب. يمكن للزبون أن يحجز من جديد إذا كان العرض ما زال متاحًا.';

  @override
  String get problemExpiredHint =>
      'لا تسلّم الطلب. يمكن للزبون أن يحجز من جديد إذا كان العرض ما زال متاحًا.';

  @override
  String get checkCustomerTitle => 'هل هو الزبون الصحيح؟';

  @override
  String checkCustomerMessage(String item, String name, String amount) {
    return 'تأكّد أنك سلّمت $item إلى $name واستلمت $amount.';
  }

  @override
  String get checkCustomerConfirm => 'نعم، تم الاستلام';

  @override
  String perPiece(String price) {
    return '$price للقطعة';
  }

  @override
  String get payInCash => 'الدفع نقدًا';

  @override
  String get figurePickedUp => 'استُلمت';

  @override
  String get figureOnTheWay => 'في الطريق';

  @override
  String get figureLeft => 'باقي';

  @override
  String get figureReady => 'جاهزة';

  @override
  String offerPriceAndWhen(String price, String when) {
    return '$price، $when';
  }

  @override
  String endsAt(String time) {
    return 'ينتهي $time';
  }

  @override
  String startsAt(String time) {
    return 'يبدأ $time';
  }

  @override
  String endedAt(String time) {
    return 'انتهى $time';
  }

  @override
  String get dayToday => 'اليوم';

  @override
  String get offerPiecesTitle => 'الكمية';

  @override
  String get offerDetailsTitle => 'التفاصيل';

  @override
  String get seenLabel => 'شاهدوه';

  @override
  String leftOfTotal(int left, int total) {
    return '$left من $total';
  }

  @override
  String dayAndTime(String day, String time) {
    return '$day $time';
  }

  @override
  String notPickedUpOrCancelled(int expired, int cancelled) {
    return '$expired لم يُستلم، $cancelled أُلغي';
  }

  @override
  String get moreActions => 'المزيد';

  @override
  String get endOfferHint => 'يختفي عند الزبائن ولا يمكن إرجاعه';

  @override
  String discountBadge(int percent) {
    return '-$percent%';
  }

  @override
  String get unlimitedHint => 'يبقى متاحًا حتى ينتهي وقته أو توقفه.';

  @override
  String get listSeparator => '، ';

  @override
  String get reservationsTitle => 'الحجز';

  @override
  String holdHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ساعة',
      few: '$hours ساعات',
      two: 'ساعتان',
      one: 'ساعة',
    );
    return '$_temp0';
  }

  @override
  String get noLimitPerCustomer => 'بدون حد لكل زبون';

  @override
  String piecesPerCustomer(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قطعة لكل زبون',
      few: '$count قطع لكل زبون',
      two: 'قطعتان لكل زبون',
      one: 'قطعة واحدة لكل زبون',
    );
    return '$_temp0';
  }

  @override
  String get atMost => 'حد أقصى';

  @override
  String get anyCustomerAll => 'يستطيع أي زبون حجز كل القطع.';

  @override
  String postSummary(String pieces, String when) {
    return '$pieces · ينتهي $when';
  }

  @override
  String get claimOutForDelivery => 'مع السائق';

  @override
  String get sendForDelivery => 'أرسل للتوصيل';

  @override
  String get markDelivered => 'تم التوصيل';

  @override
  String get notDelivered => 'لم يتم';

  @override
  String get sentForDeliveryTitle => 'مع السائق الآن';

  @override
  String get driverCollects => 'يستلمها السائق من الزبون';

  @override
  String get deliveredTitle => 'تم التوصيل';

  @override
  String get paidOnDelivery => 'تُدفع عند التوصيل';

  @override
  String checkSendMessage(String item, String name, String amount) {
    return 'سيأخذ السائق $item إلى $name ويستلم $amount.';
  }

  @override
  String checkDeliveredMessage(String item, String name, String amount) {
    return 'تأكّد أن السائق سلّم $item إلى $name واستلم $amount.';
  }

  @override
  String get notDeliveredTitle => 'لم يتم التوصيل؟';

  @override
  String notDeliveredMessage(String name) {
    return 'يُلغى الحجز وتعود قطعه للبيع، ويصل $name إشعار بذلك دون أن يُحسب عليه.';
  }

  @override
  String get cancelBooking => 'إلغاء الحجز';

  @override
  String get keepIt => 'إبقاؤه';

  @override
  String get notDeliveredDone => 'أُلغي الحجز وعادت قطعه للبيع.';

  @override
  String outForDeliverySince(String time) {
    return 'مع السائق منذ $time';
  }

  @override
  String get outForDeliveryHint =>
      'أغلقه عند التوصيل، أو إن لم يتم. بعد يوم يُعتبر قد وصل.';

  @override
  String get deliveredAtLabel => 'وقت التوصيل';

  @override
  String get sentForDeliveryAtLabel => 'مع السائق منذ';

  @override
  String get deliveriesTitle => 'التوصيلات';

  @override
  String get noDeliveriesTitle => 'لا توصيلات حاليًا';

  @override
  String get noDeliveriesMessage =>
      'تظهر هنا الحجوزات التي يأخذها السائق حتى تغلقها.';

  @override
  String get longestOutFirst => 'الأقدم أولًا';

  @override
  String get deliveriesEndNote =>
      'التوصيل الذي يبقى مفتوحًا يومًا يُعتبر قد وصل.';

  @override
  String deliveriesOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count توصيلًا بانتظار الإغلاق',
      few: '$count توصيلات بانتظار الإغلاق',
      two: 'توصيلان بانتظار الإغلاق',
      one: 'توصيل واحد بانتظار الإغلاق',
    );
    return '$_temp0';
  }

  @override
  String get deliveriesOutHint =>
      'حدّد لكل منها هل وصل. بعد يوم تُعتبر قد وصلت.';

  @override
  String get deliveryLabel => 'التوصيل';

  @override
  String get pickupOnly => 'استلام فقط';

  @override
  String get weDeliver => 'نوصّل أيضًا';

  @override
  String get weDeliverHint =>
      'يرى الزبون صاحب الحجز رقمًا يتصل به ليطلب التوصيل، والتوصيل وأي رسوم له بينك وبينه. عندما يأخذ السائق حجزًا، ابحث عن رمزه واضغط «أرسل للتوصيل».';

  @override
  String get deliveryPhoneLabel => 'رقم التوصيل';

  @override
  String get deliveryPhoneHelper => 'اتركه فارغًا ليتصل الزبائن برقم المحل.';

  @override
  String get takeBreak => 'أخذ استراحة';

  @override
  String get takeBreakHint =>
      'أوقف الحجوزات الجديدة لفترة، أو أغلق لبقية اليوم';

  @override
  String get takeBreakTitle => 'إيقاف الحجز مؤقتًا';

  @override
  String get takeBreakSubtitle =>
      'يظهر متجرك مغلقًا للزبائن فلا يمكنهم الحجز. الحجوزات الموجودة تبقى، فسلّمها كالمعتاد.';

  @override
  String breakMinutes(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get breakHour => 'ساعة';

  @override
  String get breakUntilOpen => 'حتى موعد فتحنا القادم';

  @override
  String get stopBookings => 'إيقاف الحجز';

  @override
  String get closeAndCancel => 'إغلاق الآن وإلغاء الحجوزات';

  @override
  String closeAndCancelTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إلغاء $count حجزًا؟',
      few: 'إلغاء $count حجوزات؟',
      two: 'إلغاء حجزين؟',
      one: 'إلغاء حجز واحد؟',
    );
    return '$_temp0';
  }

  @override
  String get closeAndCancelMessage =>
      'فقط إن اضطررت إلى الإغلاق ولا تستطيع تسليمها. نخبر الزبائن، ولا يُحسب ذلك عليهم.';

  @override
  String get closeAndCancelConfirm => 'إغلاق وإلغاء';

  @override
  String get keepBookings => 'إبقاؤها';

  @override
  String get noOpeningAhead => 'أوقات عملك لا تحدد متى تفتح، فاختر المدة.';

  @override
  String offlineDone(String time) {
    return 'توقف الحجز حتى $time.';
  }

  @override
  String storeClosedDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أُغلق المتجر: أُلغي $count حجزًا وأُبلغ أصحابها.',
      few: 'أُغلق المتجر: أُلغيت $count حجوزات وأُبلغ أصحابها.',
      two: 'أُغلق المتجر: أُلغي حجزان وأُبلغ صاحباهما.',
      one: 'أُغلق المتجر: أُلغي حجز واحد وأُبلغ صاحبه.',
    );
    return '$_temp0';
  }

  @override
  String offlineUntil(String time) {
    return 'الحجز متوقف حتى $time';
  }

  @override
  String get offlineMessage =>
      'لا يمكن للزبائن الحجز الآن. الحجوزات الموجودة تبقى.';

  @override
  String get backOnline => 'استئناف الحجز';

  @override
  String get backOnlineDone => 'يمكن للزبائن الحجز من جديد.';

  @override
  String get storeMissingTitle => 'أكمل بيانات متجرك';

  @override
  String get storeMissingMessage => 'متجرك ظاهر للزبائن، لكن ينقصه ما يلي.';

  @override
  String get openingHoursEveryDay => 'أوقات العمل لكل الأيام';

  @override
  String get specialDaysTitle => 'أيام خاصة';

  @override
  String get addSpecialDays => 'إضافة أيام خاصة';

  @override
  String get specialDaysHint =>
      'لرمضان أو العيد أو العطل: تحل هذه الأيام محل أوقاتك الأسبوعية.';

  @override
  String get specialDaysPickTitle => 'أي الأيام؟';

  @override
  String get specialDaysLabel => 'الأيام';

  @override
  String get specialDaysOverlap => 'هذه الأيام تتداخل مع أيام خاصة أخرى.';

  @override
  String specialDaysTooLong(int days) {
    return '$days يومًا على الأكثر في المرة الواحدة.';
  }

  @override
  String get removeSpecialDays => 'حذف هذه الأيام';

  @override
  String dayRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String holdOrClosing(String hold) {
    return '$hold، أو حتى الإغلاق';
  }
}
