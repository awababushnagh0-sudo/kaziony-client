import 'package:flutter/widgets.dart';

import 's_alert_material.dart';

/// A red box that stops the person before a mistake: what's wrong in bold
/// ([title]), and what to do about it ([message]). Read out by screen
/// readers as soon as it shows.
abstract interface class SAlert implements Widget {
  const factory SAlert({required String title, String? message, Key? key}) =
      SAlertMaterial;
}
