import 'package:flutter/widgets.dart';

import 's_status_material.dart';

/// A spinner in the middle of the area, with an optional [message] under it.
abstract interface class SLoadingView implements Widget {
  const factory SLoadingView({String? message, Key? key}) =
      SLoadingViewMaterial;
}
