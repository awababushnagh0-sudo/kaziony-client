import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_list_page_renderer.dart';

/// Page size choice, which page of how many, and previous/next.
class SPager extends StatelessWidget {
  const SPager({
    required this.pageLabel,
    required this.pageSize,
    required this.pageSizes,
    required this.onPageSize,
    required this.onPrevious,
    required this.onNext,
    required this.previousLabel,
    required this.nextLabel,
    super.key,
  });

  final String pageLabel;
  final int pageSize;
  final List<int> pageSizes;
  final ValueChanged<int> onPageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final String previousLabel;
  final String nextLabel;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).listPage.pager(
    context,
    PagerSpec(
      pageLabel: pageLabel,
      pageSize: pageSize,
      pageSizes: pageSizes,
      onPageSize: onPageSize,
      onPrevious: onPrevious,
      onNext: onNext,
      previousLabel: previousLabel,
      nextLabel: nextLabel,
    ),
  );
}
