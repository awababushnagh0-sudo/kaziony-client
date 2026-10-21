import 'package:flutter/widgets.dart';

/// The bar above a list: a search box, then filter pills.
class SFilterBar extends StatelessWidget {
  const SFilterBar({required this.search, this.filters = const [], super.key});

  final Widget search;
  final List<Widget> filters;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 14, 24, 12),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 640;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(width: narrow ? constraints.maxWidth : 280, child: search),
            ...filters,
          ],
        );
      },
    ),
  );
}
