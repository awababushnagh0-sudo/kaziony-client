import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart' show AppFailure;

import '../../foundation/s_kit.dart';
import 's_paged_list_renderer.dart';

/// A phone list that loads more rows as the user nears its end, and
/// reloads when pulled down, as in the big apps. Rows are separated by
/// thin lines.
class SPagedList extends StatelessWidget {
  const SPagedList({
    required this.itemCount,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    this.hasMore = false,
    this.loadingMore = false,
    this.moreFailure,
    this.header,
    this.endNote,
    this.divided = true,
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// Pulling down reloads the list; the spinner stays until it completes.
  final Future<void> Function() onRefresh;

  /// Called near the end while [hasMore], and by "Try again" after
  /// [moreFailure].
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool loadingMore;

  /// Loading the next rows failed: the end of the list offers a retry.
  final AppFailure? moreFailure;

  /// Above the rows, scrolling with them (a summary of the list).
  final Widget? header;

  /// Quiet text under the last row once everything has loaded (what the
  /// list holds and for how long).
  final String? endNote;

  /// Lines between the rows; turn off for rows that are cards of their
  /// own, which get a gap instead.
  final bool divided;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).pagedList.render(
    context,
    PagedListSpec(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      onRefresh: onRefresh,
      onLoadMore: onLoadMore,
      hasMore: hasMore,
      loadingMore: loadingMore,
      moreFailure: moreFailure,
      header: header,
      endNote: endNote,
      divided: divided,
    ),
  );
}
