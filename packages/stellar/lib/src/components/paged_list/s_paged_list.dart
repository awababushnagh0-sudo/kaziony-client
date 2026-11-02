import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart' show AppFailure;

import 's_paged_list_material.dart';

/// A phone list that loads more rows as the user nears its end, and
/// reloads when pulled down, as in the big apps. Rows are separated by
/// thin lines.
abstract interface class SPagedList implements Widget {
  /// Pulling down calls [onRefresh]; the spinner stays until it completes.
  /// [onLoadMore] is called near the end while [hasMore], and by "Try
  /// again" after [moreFailure] (loading the next rows failed: the end of
  /// the list offers a retry).
  ///
  /// [header] sits above the rows, scrolling with them (a summary of the
  /// list). [endNote] is quiet text under the last row once everything has
  /// loaded (what the list holds and for how long). Turn [divided] off for
  /// rows that are cards of their own, which get a gap instead of a line.
  const factory SPagedList({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    required Future<void> Function() onRefresh,
    required VoidCallback onLoadMore,
    bool hasMore,
    bool loadingMore,
    AppFailure? moreFailure,
    Widget? header,
    String? endNote,
    bool divided,
    Key? key,
  }) = SPagedListMaterial;
}
