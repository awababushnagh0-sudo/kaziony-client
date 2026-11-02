import 'package:flutter/widgets.dart';

import 's_list_page_material.dart';

/// Page size choice, which page of how many, and previous/next.
abstract interface class SPager implements Widget {
  /// [pageLabel] reads "Page 1 of 3". [onPrevious] and [onNext] are null on
  /// the first and last page.
  const factory SPager({
    required String pageLabel,
    required int pageSize,
    required List<int> pageSizes,
    required ValueChanged<int> onPageSize,
    required VoidCallback? onPrevious,
    required VoidCallback? onNext,
    required String previousLabel,
    required String nextLabel,
    Key? key,
  }) = SPagerMaterial;
}
