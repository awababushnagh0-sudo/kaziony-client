import 'package:flutter/widgets.dart';

import 's_logo_material.dart';

/// A store's logo, round, on a light plate that a little of what's under it
/// shows through: for a logo over a photo (an offer's card). The store icon
/// when it has none. Screen readers say [storeName].
abstract interface class SLogo implements Widget {
  /// [url] is null when the store has no logo.
  const factory SLogo(String? url, {required String storeName, Key? key}) =
      SLogoMaterial;
}
