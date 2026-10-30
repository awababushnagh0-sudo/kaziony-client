import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart' show AppFailure;

@immutable
class PagedListSpec {
  const PagedListSpec({
    required this.itemCount,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    required this.hasMore,
    required this.loadingMore,
    required this.moreFailure,
    this.header,
    this.endNote,
    this.divided = true,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool loadingMore;
  final AppFailure? moreFailure;
  final Widget? header;
  final String? endNote;

  /// Lines between the rows; otherwise a gap, for rows that are cards.
  final bool divided;
}

abstract interface class PagedListRenderer {
  Widget render(BuildContext context, PagedListSpec spec);
}
