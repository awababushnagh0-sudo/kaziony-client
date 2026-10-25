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
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool loadingMore;
  final AppFailure? moreFailure;
}

abstract interface class PagedListRenderer {
  Widget render(BuildContext context, PagedListSpec spec);
}
