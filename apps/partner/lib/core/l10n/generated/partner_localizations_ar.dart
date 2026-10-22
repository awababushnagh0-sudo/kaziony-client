// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'partner_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class PartnerLocalizationsAr extends PartnerLocalizations {
  PartnerLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'عروض للمتاجر';

  @override
  String get switchLanguage => 'English';

  @override
  String get loginTitle => 'دخول المتجر';

  @override
  String get loginSubtitle =>
      'استخدم رقم الهاتف وكلمة المرور التي حصلت عليها من فريقنا.';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'دخول';

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
  String get branchesTitle => 'الفروع';

  @override
  String get storeActive => 'مفعّل';

  @override
  String get storeDisabled => 'موقوف. تواصل معنا لإعادة تفعيله.';

  @override
  String get branchClosed => 'مغلق';

  @override
  String get cityTripoli => 'طرابلس';

  @override
  String get ownerRole => 'مالك';

  @override
  String get staffRole => 'موظف';

  @override
  String get noStoreTitle => 'لا يوجد متجر مرتبط بهذا الحساب';

  @override
  String get noStoreMessage => 'تواصل مع فريقنا لإعداد متجرك.';

  @override
  String get comingNext => 'المنتجات والعروض في الخطوة القادمة.';
}
