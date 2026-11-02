import 'package:flutter/widgets.dart';

import 's_status_material.dart';

/// Full-screen "please update" shown when this version is too old.
abstract interface class SUpdateRequiredView implements Widget {
  const factory SUpdateRequiredView({Key? key}) = SUpdateRequiredViewMaterial;
}
