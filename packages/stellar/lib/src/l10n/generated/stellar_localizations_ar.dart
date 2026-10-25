// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'stellar_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class StellarLocalizationsAr extends StellarLocalizations {
  StellarLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get retry => 'حاول مرة أخرى';

  @override
  String get cancel => 'إلغاء';

  @override
  String get ok => 'حسناً';

  @override
  String get loading => 'جاري التحميل…';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get errorNoConnectionTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get errorNoConnectionMessage => 'تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get errorTimeout => 'الخادم يتأخر في الرد. حاول مرة أخرى.';

  @override
  String get errorServer => 'حدث خطأ من جهتنا. حاول بعد قليل.';

  @override
  String get errorUnknown => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get errorNotFound => 'غير موجود. ربما تم حذفه.';

  @override
  String get errorForbidden => 'ليس لديك صلاحية لهذا.';

  @override
  String get errorUnauthorized => 'انتهت الجلسة. سجّل الدخول مرة أخرى.';

  @override
  String get errorRateLimited => 'محاولات كثيرة. انتظر دقيقة وحاول مرة أخرى.';

  @override
  String get errorPasswordChangeRequired => 'غيّر كلمة المرور المؤقتة أولاً.';

  @override
  String get errorInvalid => 'تحقق من البيانات وحاول مرة أخرى.';

  @override
  String get validationRequired => 'مطلوب';

  @override
  String validationMinLength(int count) {
    return '$count أحرف على الأقل';
  }

  @override
  String validationMaxLength(int count) {
    return '$count حرفاً كحد أقصى';
  }

  @override
  String get validationPhone => 'أدخل رقم هاتف ليبي، مثل 0912345678';

  @override
  String get validationEmail => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get validationUrl => 'أدخل رابطاً صحيحاً يبدأ بـ https://';

  @override
  String get validationMustMatch => 'غير متطابق';

  @override
  String get updateRequiredTitle => 'يلزم التحديث';

  @override
  String get updateRequiredMessage =>
      'هذا الإصدار من التطبيق لم يعد مدعوماً. حدّثه من المتجر للمتابعة.';

  @override
  String get close => 'إغلاق';

  @override
  String get copy => 'نسخ';

  @override
  String get copied => 'تم النسخ';

  @override
  String get language => 'اللغة';

  @override
  String get validationPrice => 'أدخل سعرًا أكبر من صفر، مثل 4.500';

  @override
  String get currency => 'د.ل';

  @override
  String get photo => 'الصورة';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get choosePhoto => 'اختيار من المعرض';

  @override
  String get addPhoto => 'إضافة صورة';

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String photoUploading(int percent) {
    return 'جارٍ الرفع… $percent%';
  }

  @override
  String get photoUploadFailed => 'لم تُرفع الصورة. اضغط للمحاولة مرة أخرى.';

  @override
  String get photoFailed => 'تعذّر استخدام هذه الصورة. جرّب صورة أخرى.';

  @override
  String get cameraOffTitle => 'الكاميرا متوقفة';

  @override
  String get cameraOffMessage =>
      'اسمح لهذا التطبيق باستخدام الكاميرا من الإعدادات لالتقاط الصور.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String validationWholeNumber(int min, int max) {
    return 'أدخل رقمًا صحيحًا من $min إلى $max';
  }

  @override
  String get chooseDateTime => 'اختر اليوم والوقت';
}
