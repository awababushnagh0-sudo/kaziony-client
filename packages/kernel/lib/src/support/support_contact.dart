import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_api/auth.dart' as api;

import '../network/api.dart';

/// How to reach our team. It comes from the backend, so a new number
/// doesn't need a new app.
@immutable
class SupportContact {
  const SupportContact({
    required this.phone,
    required this.whatsapp,
    required this.email,
    required this.hoursAr,
    required this.hoursEn,
  });

  final String phone;

  /// International, digits only ("218910000000").
  final String whatsapp;
  final String email;
  final String hoursAr;
  final String hoursEn;

  /// When the team answers, in [locale]'s language.
  String hoursIn(Locale locale) =>
      locale.languageCode == 'ar' ? hoursAr : hoursEn;

  Uri get callLink => Uri(scheme: 'tel', path: phone);
  Uri get whatsappLink => Uri.https('wa.me', '/$whatsapp');
  Uri get emailLink => Uri(scheme: 'mailto', path: email);
}

/// Loaded when a page shows it; throws an `AppFailure` when it can't be.
final supportContactProvider = FutureProvider.autoDispose<SupportContact>((
  ref,
) async {
  final publicApi = ref.read(publicApiProvider);
  final client = publicApi.client(api.AppConfigClient.new);
  final config = (await publicApi.guard(client.getAppConfig)).valueOrThrow;
  final support = config.support;
  return SupportContact(
    phone: support.phone,
    whatsapp: support.whatsapp,
    email: support.email,
    hoursAr: support.hoursAr,
    hoursEn: support.hoursEn,
  );
});
