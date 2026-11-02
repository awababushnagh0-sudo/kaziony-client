// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'customer_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class CustomerLocalizationsAr extends CustomerLocalizations {
  CustomerLocalizationsAr([String locale = 'ar']) : super(locale);

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
  String get helloTitle => 'أهلاً بك في كزيوني';

  @override
  String get helloText => 'قريباً هنا عروض المتاجر القريبة منك.';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get signInTitle => 'سجّل دخولك';

  @override
  String get signInMessage =>
      'لتحجز العروض وتتابع متاجرك المفضلة. التصفح متاح بدون حساب.';

  @override
  String get guestTitle => 'أهلًا بك، ضيفنا العزيز!';

  @override
  String get guestMessage =>
      'سجّل دخولك لتحجز العروض قبل أن تنفد، وتتابع متاجرك المفضلة.';

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
  String get logout => 'تسجيل الخروج';

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
}
