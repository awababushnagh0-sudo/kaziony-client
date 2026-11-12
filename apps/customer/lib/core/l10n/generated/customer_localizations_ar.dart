// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'customer_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class CustomerLocalizationsAr extends CustomerLocalizations {
  CustomerLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get offerFactPickup => 'الاستلام';

  @override
  String get offerFactLeft => 'المتبقي';

  @override
  String offerFactLeftValue(int left, int total) {
    return '$left من $total';
  }

  @override
  String get offerInfoToday => 'اليوم';

  @override
  String cardPickupBetween(String day, String start, String end) {
    return '$day $start – $end';
  }

  @override
  String cardPickupUntil(String day, String time) {
    return '$day حتى $time';
  }

  @override
  String get offerInfoTomorrow => 'غدًا';

  @override
  String ratingLabel(String average, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تقييم',
      few: '$count تقييمات',
      two: 'تقييمان',
      one: 'تقييم واحد',
    );
    return 'التقييم $average من 5، $_temp0';
  }

  @override
  String ratingStars(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نجمة',
      few: '$count نجوم',
      two: 'نجمتان',
      one: 'نجمة واحدة',
    );
    return '$_temp0';
  }

  @override
  String ratingPrompt(String store) {
    return 'كيف كان $store؟';
  }

  @override
  String get ratingPromptMessage =>
      'قيّم المحل، تقييمك يساعد غيرك في الاختيار.';

  @override
  String ratingGiven(String store) {
    return 'قيّمت $store';
  }

  @override
  String get ratingThanks => 'شكرًا على تقييمك!';

  @override
  String get ratingSend => 'إرسال التقييم';

  @override
  String get ratingNotPickedUp => 'تقدر تقيّم المحل بعد ما تستلم طلبك.';

  @override
  String get ratingAlreadyRated =>
      'قيّمت هذا المحل من هذا الاستلام أو من استلام بعده.';

  @override
  String get ratingAgainMessage =>
      'استلمت منه من جديد: قيّمه مرة أخرى، ونجومك الجديدة تحل محل القديمة.';

  @override
  String get ratingOnePerStore =>
      'تقييم واحد لكل محل. استلم منه مرة أخرى لتغيّره.';

  @override
  String get ratingUpdate => 'تحديث التقييم';

  @override
  String get pickupInstructionsTitle => 'طريقة الاستلام';

  @override
  String get pickupInstructionsDefault =>
      'اعرض رمز الاستلام على أحد العاملين في المحل، ويسلّمك طلبك.';

  @override
  String get homeStoresNearby => 'محلات قريبة منك';

  @override
  String get homeFavoriteStores => 'محلاتك المفضلة';

  @override
  String get homeAllOffersTitle => 'تصفّح كل العروض حولك';

  @override
  String homeAllOffersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عرضًا يستنوك، الأحدث أولًا',
      few: '$count عروض تستناك، الأحدث أولًا',
      two: 'عرضان يستنوك، الأحدث أولًا',
      one: 'عرض واحد يستناك، الأحدث أولًا',
    );
    return '$_temp0';
  }

  @override
  String get homeBannerRescueTitle => 'أكل طيب.. قبل ما يسكّر المحل';

  @override
  String get homeBannerRescueMessage =>
      'اللي فاضل في المحلات آخر النهار، بسعر أقل بكثير.';

  @override
  String get homeBannerPickupTitle => 'احجز من هنا، واستلم من المحل';

  @override
  String get homeBannerPickupMessage =>
      'عرضك محجوز ويستناك في المحل، تعال خوذه بس.';

  @override
  String get homeBannerCashTitle => 'ادفع كاش في المحل';

  @override
  String get homeBannerCashMessage => 'ما تحتاجش بطاقة: تدفع وقت الاستلام.';

  @override
  String offerPageReserveCount(int count) {
    return 'احجز $count';
  }

  @override
  String offerPageConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تحجز $count قطعة؟',
      few: 'تحجز $count قطع؟',
      two: 'تحجز قطعتين؟',
      one: 'تحجز قطعة واحدة؟',
    );
    return '$_temp0';
  }

  @override
  String get offerPageAbout => 'عن العرض';

  @override
  String get offerPageGoodToKnow => 'قبل أن تحجز';

  @override
  String get storeGetDirections => 'عرض الاتجاهات';

  @override
  String get storeDirectionsFailed => 'تعذّر فتح الخريطة. حاول مرة أخرى.';

  @override
  String openToday(String hours) {
    return 'مفتوح اليوم $hours';
  }

  @override
  String get closedToday => 'مغلق اليوم';

  @override
  String hoursBetween(String open, String close) {
    return '$open – $close';
  }

  @override
  String get callAction => 'اتصال';

  @override
  String get callFailed => 'تعذّر بدء الاتصال. حاول مرة أخرى.';

  @override
  String get storeAddFavorite => 'أضف إلى المفضلة';

  @override
  String get storeRemoveFavorite => 'أزل من المفضلة';

  @override
  String get storeFavoriteSignInTitle => 'سجّل الدخول لتحفظ محلاتك المفضلة';

  @override
  String get storeFavoriteSignInMessage =>
      'احفظ المحلات التي تحبها لتجد عروضها في مكان واحد.';

  @override
  String get storeOffersNow => 'العروض الآن';

  @override
  String get storeNoOffers => 'لا عروض الآن. عُد لاحقًا.';

  @override
  String get searchCraving => 'ماذا تشتهي اليوم؟';

  @override
  String get searchRecent => 'عمليات بحث سابقة';

  @override
  String get searchClearRecent => 'مسح';

  @override
  String get searchStoresNear => 'المحلات القريبة';

  @override
  String get searchStores => 'المحلات';

  @override
  String get searchOffers => 'العروض';

  @override
  String get searchNoOffers => 'لا توجد عروض مطابقة الآن.';

  @override
  String searchOffersNow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عرضًا الآن',
      few: '$count عروض الآن',
      two: 'عرضان الآن',
      one: 'عرض واحد الآن',
    );
    return '$_temp0';
  }

  @override
  String get appTitle => 'كزيوني';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get searchTitle => 'بحث';

  @override
  String get bookingsTitle => 'حجوزاتي';

  @override
  String get favoritesTitle => 'المفضلة';

  @override
  String get accountTitle => 'حسابي';

  @override
  String get signInTitle => 'سجّل دخولك';

  @override
  String get signInMessage =>
      'لتحجز العروض وتحفظ متاجرك المفضلة. التصفح متاح بدون حساب.';

  @override
  String get guestTitle => 'أهلًا بك، ضيفنا العزيز!';

  @override
  String get guestMessage =>
      'سجّل دخولك لتحجز العروض قبل أن تنفد، وتحفظ متاجرك المفضلة.';

  @override
  String get reserveSignInTitle => 'سجّل دخولك لتحجز';

  @override
  String get reserveSignInMessage =>
      'احجز العرض الآن واستلمه من المحل. الأمر يأخذ لحظة فقط.';

  @override
  String get signInAction => 'تسجيل الدخول';

  @override
  String get termsAgreement => 'بالمتابعة توافق على';

  @override
  String get termsTitle => 'الشروط وسياسة الخصوصية';

  @override
  String get termsSoonTitle => 'قريبًا';

  @override
  String get termsSoonMessage =>
      'ستكون الشروط وسياسة الخصوصية هنا قبل أن يُفتح التطبيق للجميع.';

  @override
  String get bookingsSignedOutTitle => 'سجّل دخولك لترى حجوزاتك';

  @override
  String get bookingsSignedOutMessage => 'حجوزاتك ورموز الاستلام تظهر هنا.';

  @override
  String get appSection => 'التطبيق';

  @override
  String get aboutSection => 'عن كزيوني';

  @override
  String get greetingMorning => 'صباح الخير،';

  @override
  String get greetingEvening => 'مساء الخير،';

  @override
  String get ratingsTitle => 'تقييماتي';

  @override
  String get ratingsEmptyTitle => 'ما قيّمت أي محل بعد';

  @override
  String get ratingsEmptyMessage =>
      'بعد ما تستلم طلبك، قيّم المحل من صفحة الحجز.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutTitle => 'تسجيل الخروج؟';

  @override
  String get logoutMessage =>
      'تبقى حجوزاتك ومحلاتك المفضلة محفوظة. سجّل الدخول مرة أخرى لتراها.';

  @override
  String get deleteAccount => 'حذف حسابي';

  @override
  String get deleteAccountTitle => 'حذف حسابك؟';

  @override
  String get deleteAccountMessage =>
      'يُمسح اسمك وبريدك وحجوزاتك ومحلاتك المفضلة وتقييماتك نهائيًا، وتعود القطع المحجوزة للبيع. لا يمكن التراجع عن هذا.';

  @override
  String get deleteAccountConfirm => 'احذف';

  @override
  String get accountDeleted => 'تم حذف حسابك.';

  @override
  String get back => 'رجوع';

  @override
  String get tagline => 'لأن الخير ما يتلوحش';

  @override
  String get helloMessage =>
      'عروض حقيقية من محلات قريبة منك، بكميات محدودة. احجز قبل ما تخلص.';

  @override
  String get whyTitle => 'ليش كزيوني؟';

  @override
  String get whyLessWaste => 'أكل أقل في الزبالة، وخير أكثر يوصل للناس.';

  @override
  String get whySaveMoney => 'نفس الجودة بسعر أقل.';

  @override
  String get whyLocalStores => 'تدعم المحلات اللي في حيّك.';

  @override
  String get howTitle => 'كيف يخدم؟';

  @override
  String get howBook => 'احجز العرض من التطبيق.';

  @override
  String get howPickUp => 'استلمه من المحل في وقته.';

  @override
  String get howPay => 'ادفع كاش عند الاستلام.';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'يلا نبدأ';

  @override
  String get locationTitle => 'وين أنت؟';

  @override
  String get locationMessage =>
      'نعرض لك عروض المحلات القريبة منك بس. موقعك ما يطلع لأي محل.';

  @override
  String get useMyLocation => 'استخدم موقعي';

  @override
  String get locationDenied => 'ما سمحتش بالموقع. تقدر تحدد مكانك على الخريطة.';

  @override
  String get locationDeniedForever =>
      'الموقع مقفول لكزيوني. افتح الإعدادات وسمح بيه، أو حدّد مكانك على الخريطة.';

  @override
  String get locationOff =>
      'الموقع مقفول في هاتفك. شغّله أو حدّد مكانك على الخريطة.';

  @override
  String get locationFailed =>
      'ما قدرناش نعرف موقعك. جرّب مرة ثانية أو حدّد مكانك على الخريطة.';

  @override
  String get myLocation => 'موقعي الحالي';

  @override
  String get locationRow => 'الموقع';

  @override
  String get continueAsGuest => 'الدخول كضيف';

  @override
  String get appleSignInSoon => 'الدخول بحساب Apple قريباً.';

  @override
  String get setOnMap => 'حدّد على الخريطة';

  @override
  String get mapTitle => 'حدّد مكانك';

  @override
  String get mapHint => 'حرّك الخريطة حتى يكون الدبوس على مكانك.';

  @override
  String get confirmPlace => 'تأكيد المكان';

  @override
  String get myLocationButton => 'موقعي';

  @override
  String get pinnedLocation => 'مكان على الخريطة';

  @override
  String get listSeparator => '، ';

  @override
  String outsideServiceArea(String areas) {
    return 'كزيوني متوفر حالياً في $areas فقط.';
  }

  @override
  String offersWithin(String km) {
    return 'عروض ضمن $km كم';
  }

  @override
  String get offersNearby => 'عروض قريبة';

  @override
  String get searchHint => 'ابحث عن محل أو عرض';

  @override
  String get allCategories => 'الكل';

  @override
  String get sectionEndingSoon => 'ينتهي قريبًا';

  @override
  String get sectionNearby => 'قريب منك';

  @override
  String get sectionBiggestDiscount => 'أكبر خصم';

  @override
  String get sectionAllOffers => 'كل العروض';

  @override
  String get viewAsCards => 'عرض كبطاقات';

  @override
  String get viewAsList => 'عرض كقائمة';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get noOffersTitle => 'لا توجد عروض قريبة الآن';

  @override
  String get noOffersMessage =>
      'المحلات تنشر عروضها خلال اليوم. ارجع بعد قليل أو غيّر المكان.';

  @override
  String get changePlace => 'غيّر المكان';

  @override
  String discountOff(int percent) {
    return 'خصم $percent٪';
  }

  @override
  String piecesLeft(int count) {
    return 'باقي $count';
  }

  @override
  String distanceKm(String km) {
    return '$km كم';
  }

  @override
  String get sortNearest => 'الأقرب';

  @override
  String get sortEndingSoon => 'ينتهي قريبًا';

  @override
  String get sortNewest => 'الأحدث';

  @override
  String get sortBiggestDiscount => 'أكبر خصم';

  @override
  String get sortTitle => 'ترتيب العروض';

  @override
  String get noResultsTitle => 'لا توجد نتائج';

  @override
  String get noResultsMessage => 'جرّب كلمة أخرى أو قسمًا آخر.';

  @override
  String noResultsFor(String words) {
    return 'لا توجد نتائج لـ«$words» قريبًا منك';
  }

  @override
  String get noResultsNearby =>
      'المحلات تنشر عروضًا جديدة كل يوم. إليك العروض القريبة منك الآن.';

  @override
  String holdTitle(String time) {
    return 'عندك $time للاستلام';
  }

  @override
  String get holdMessage => 'من وقت الحجز، ولا يتجاوز نهاية العرض.';

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
  String holdMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes دقيقة',
      few: '$minutes دقائق',
      two: 'دقيقتان',
      one: 'دقيقة',
    );
    return '$_temp0';
  }

  @override
  String holdHoursAndMinutes(String hours, String minutes) {
    return '$hours و$minutes';
  }

  @override
  String get untilEndTitle => 'رمزك صالح حتى نهاية العرض';

  @override
  String get untilEndMessage => 'استلمه في أي وقت قبل أن ينتهي العرض.';

  @override
  String get payTitle => 'الدفع نقدًا في المحل';

  @override
  String get payMessage => 'لا تدفع شيئًا الآن.';

  @override
  String limitPerCustomer(int count) {
    return 'حد أقصى $count لكل زبون';
  }

  @override
  String get reserveNow => 'احجز الآن';

  @override
  String get showMyCode => 'عرض رمز الاستلام';

  @override
  String get soldOut => 'نفدت الكمية';

  @override
  String pricePerPiece(String price) {
    return '$price للقطعة';
  }

  @override
  String get reserveConfirm => 'تأكيد الحجز';

  @override
  String reserveHoldNote(String time) {
    return 'عندك $time للاستلام، وتدفع نقدًا وقتها.';
  }

  @override
  String get reserveUntilEndNote =>
      'رمزك صالح حتى نهاية العرض، وتدفع نقدًا عند الاستلام.';

  @override
  String get reserveAlreadyReserved => 'عندك حجز لهذا العرض.';

  @override
  String get reserveLimitReached => 'أخذت أقصى ما يسمح به هذا العرض.';

  @override
  String get reserveOverLimit => 'لا يمكنك أخذ هذا العدد. جرّب أقل.';

  @override
  String get reserveTooMany =>
      'عندك أقصى عدد من الحجوزات في نفس الوقت. استلم أحدها أو ألغِه أولًا.';

  @override
  String reserveFullNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'عندك $count حجزًا، وهذا الحد في نفس الوقت. استلم أو ألغِ أحدها لتحجز هذا العرض.',
      few:
          'عندك $count حجوزات، وهذا الحد في نفس الوقت. استلم أو ألغِ أحدها لتحجز هذا العرض.',
      two: 'عندك حجزان، وهذا الحد في نفس الوقت. استلم أو ألغِ أحدهما لتحجز هذا العرض.',
      one: 'عندك حجز واحد، وهو الحد في نفس الوقت. استلمه أو ألغِه لتحجز هذا العرض.',
    );
    return '$_temp0';
  }

  @override
  String get reserveCancelledTooOften =>
      'ألغيت هذا العرض مرتين، فلا يمكنك حجزه مرة أخرى.';

  @override
  String get reserveNotEnough => 'لم يبقَ هذا العدد. جرّب أقل.';

  @override
  String get reserveNotStarted => 'هذا العرض لم يبدأ بعد.';

  @override
  String get reserveEnded => 'انتهى هذا العرض.';

  @override
  String get reservePaused => 'الحجز موقوف لأيام بسبب استلامات فاتتك.';

  @override
  String bookingPausedUntil(String when) {
    return 'الحجز موقوف حتى $when';
  }

  @override
  String get bookingPausedMessage =>
      'بسبب استلامات فاتتك، ويرجع وحده في موعده.';

  @override
  String missedPickups(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'فاتك استلام $count حجزًا',
      few: 'فاتك استلام $count حجوزات',
      two: 'فاتك استلام حجزين',
      one: 'فاتك استلام حجز',
    );
    return '$_temp0';
  }

  @override
  String missedLeftBeforePause(int left, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days يومًا',
      few: '$days أيام',
      two: 'يومين',
      one: 'يومًا',
    );
    return 'بقي لك $left قبل إيقاف الحجز $_temp0.';
  }

  @override
  String missedFadesOn(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'وأقدمها لا يُحسب عليك بعد $date.',
      one: 'ولا يُحسب عليك بعد $date.',
    );
    return '$_temp0';
  }

  @override
  String missedLeftShort(int left) {
    return 'بقي لك $left قبل الإيقاف';
  }

  @override
  String get reserved => 'تم الحجز!';

  @override
  String get bookingTitle => 'تفاصيل الحجز';

  @override
  String get qrLabel => 'رمز QR لعرضه في المحل';

  @override
  String validUntil(String time) {
    return 'صالح حتى $time';
  }

  @override
  String get bookingReadyTitle => 'حجزك جاهز';

  @override
  String get bookingReadyBanner => 'حجزك جاهز للاستلام';

  @override
  String get closeAction => 'إغلاق';

  @override
  String get pickupTimeLeftLabel => 'متبقي للاستلام';

  @override
  String oneCodeFor(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'رمز واحد لـ$count قطعة',
      few: 'رمز واحد لـ$count قطع',
      two: 'رمز واحد للقطعتين',
    );
    return '$_temp0';
  }

  @override
  String get copyCode => 'انسخ الرمز';

  @override
  String get codeCopied => 'نُسخ الرمز';

  @override
  String get codeHint =>
      'اعرض الرمز للموظف، أو أعطه الحروف إذا لم تقرأه الكاميرا. اضغط على الرمز لنسخه.';

  @override
  String get directionsAction => 'الاتجاهات';

  @override
  String get pickupWhereTitle => 'أين تستلم';

  @override
  String get bookingsNow => 'الحالية';

  @override
  String get bookingsToday => 'اليوم';

  @override
  String get bookingsYesterday => 'أمس';

  @override
  String pickUpBefore(String time) {
    return 'استلم قبل $time';
  }

  @override
  String get offerEndsLabel => 'ينتهي العرض';

  @override
  String get showCode => 'عرض رمز الاستلام';

  @override
  String get payInCash => 'نقدًا عند الاستلام';

  @override
  String get factPieces => 'القطع';

  @override
  String get factTotal => 'المجموع';

  @override
  String get factBookedAt => 'وقت الحجز';

  @override
  String get factPickedUpAt => 'وقت الاستلام';

  @override
  String get payCashTitle => 'ادفع نقدًا عند الاستلام';

  @override
  String priceEach(int count, String price) {
    return '$count × $price';
  }

  @override
  String get cancelNoPenalty => 'إلغاء الحجز (بدون مخالفة)';

  @override
  String quantityTimes(int count) {
    return '×$count';
  }

  @override
  String get cancelBooking => 'إلغاء الحجز';

  @override
  String get cancelBookingTitle => 'إلغاء الحجز؟';

  @override
  String get cancelBookingMessage => 'ترجع القطع للعرض، ولا يُحسب عليك.';

  @override
  String get cancelEndsBookingMessage =>
      'ترجع القطع للعرض. ألغيته مرة من قبل، فلن تستطيع حجز هذا العرض مرة أخرى.';

  @override
  String get keepBooking => 'لا، أبقِه';

  @override
  String get bookingCancelled => 'تم إلغاء الحجز';

  @override
  String get bookingPickedUp => 'تم الاستلام، بالهناء والعافية!';

  @override
  String get statusReserved => 'بانتظار الاستلام';

  @override
  String get statusPickedUp => 'تم الاستلام';

  @override
  String get statusExpired => 'انتهى الوقت';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get bookingsEmptyTitle => 'لا حجوزات بعد';

  @override
  String get bookingsEmptyMessage => 'احجز عرضًا وسيظهر رمز استلامه هنا.';

  @override
  String get favoritesEmptyTitle => 'لا محلات مفضلة بعد';

  @override
  String get favoritesEmptyMessage =>
      'اضغط على القلب في صفحة أي محل ليظهر هنا.';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsEmptyTitle => 'لا إشعارات بعد';

  @override
  String get notificationsEmptyMessage =>
      'ستظهر هنا أخبار حجوزاتك ومحلاتك المفضلة.';

  @override
  String get notificationsSignInTitle => 'سجّل الدخول لتصلك الإشعارات';

  @override
  String get notificationsSignInMessage =>
      'اعرف متى يقترب انتهاء حجزك ومتى تنشر محلاتك المفضلة عروضًا.';

  @override
  String notificationBookingCancelled(String store) {
    return 'أُلغي حجزك في $store';
  }

  @override
  String notificationAbout(String offer, String why) {
    return '$offer. $why';
  }

  @override
  String get cancelledByUsTitle => 'ألغى كزيوني هذا الحجز';

  @override
  String get cancelledOfferRemoved => 'أوقفنا هذا العرض، ولا يُحسب هذا عليك.';

  @override
  String get cancelledStoreOff =>
      'هذا المحل لا يستقبل الحجوزات حاليًا، ولا يُحسب هذا عليك.';

  @override
  String get cancelledNotByYouTitle => 'أُلغي هذا الحجز';

  @override
  String get cancelledNotByYou => 'لم يكن ذلك منك، فلا يُحسب عليك.';

  @override
  String get refresh => 'تحديث';

  @override
  String get browseOffers => 'تصفّح العروض';

  @override
  String get placesTitle => 'وين نوريك العروض؟';

  @override
  String get addPlace => 'أضف مكان';

  @override
  String get findingLocation => 'نحدد في موقعك…';

  @override
  String get addPlaceTitle => 'أضف مكان';

  @override
  String get addPlaceMessage =>
      'البيت، الشغل، أو بيت العيلة: احفظه مرة وبدّل بينهم بضغطة.';

  @override
  String get placeNameLabel => 'الاسم';

  @override
  String get placeNameHint => 'مثلاً: البيت، الشغل، بيت جدي';

  @override
  String get savePlace => 'احفظ';

  @override
  String get placeDetailsTitle => 'شن تسمّي المكان؟';

  @override
  String get placeNoteLabel => 'وصف (اختياري)';

  @override
  String get placeNoteHint => 'مثلاً: الدور الثاني، قدام الجامع';

  @override
  String get editPlaceTitle => 'عدّل المكان';

  @override
  String get placeOnMap => 'المكان على الخريطة';

  @override
  String get placeMoved => 'تغيّر';

  @override
  String get deletePlace => 'احذف المكان';

  @override
  String get switchPlaceTitle => 'نبدّل المكان؟';

  @override
  String switchPlaceMessage(String name) {
    return 'نوريك العروض قرب «$name».';
  }

  @override
  String get switchPlace => 'بدّل';

  @override
  String deletePlaceTitle(String name) {
    return 'تحذف «$name»؟';
  }

  @override
  String get deletePlaceMessage => 'تقدر تضيفه من جديد وقت ما تبي.';

  @override
  String get placesSignInTitle => 'سجّل دخولك باش تحفظ أماكنك';

  @override
  String get placeSaved => 'حفظنا المكان';

  @override
  String get placeUpdated => 'عدّلنا المكان';

  @override
  String get placeDeleted => 'حذفنا المكان';

  @override
  String get statusOutForDelivery => 'في الطريق إليك';

  @override
  String get withTheStoresDriver => 'مع سائق المحل';

  @override
  String get bookingOnItsWayBanner => 'حجزك في الطريق إليك';

  @override
  String get bookingOnItsWayTitle => 'حجزك في الطريق إليك';

  @override
  String get bookingDelivered => 'وصل حجزك، بالهناء والعافية!';

  @override
  String get bookingSentForDelivery => 'حجزك الآن مع سائق المحل.';

  @override
  String get cancelByCallingStore => 'للإلغاء اتصل بالمحل';

  @override
  String get payDriverTitle => 'ادفع للسائق نقدًا';

  @override
  String get callAboutDelivery => 'اتصل بخصوص التوصيل';

  @override
  String get storeDelivers => 'هذا المحل يوصّل';

  @override
  String storeDeliversHint(String phone) {
    return 'اتصل على $phone واقرأ لهم رمزك. التوصيل وأي رسوم له تتفق عليها مع المحل.';
  }

  @override
  String onItsWaySince(String time) {
    return 'مع سائق المحل منذ $time';
  }

  @override
  String get factDeliveredAt => 'وقت التوصيل';

  @override
  String get cancelledNotDeliveredTitle => 'ألغى المحل هذا التوصيل';

  @override
  String get cancelledNotDelivered =>
      'يقول المحل إن التوصيل لم يتم، ولا يُحسب هذا عليك.';
}
