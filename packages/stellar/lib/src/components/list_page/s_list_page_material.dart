import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../pill/s_pill_renderer.dart';
import 's_list_page_renderer.dart';

class MaterialListPageRenderer implements ListPageRenderer {
  const MaterialListPageRenderer();

  @override
  Widget render(BuildContext context, ListPageSpec spec) =>
      _ListPage(spec: spec);

  @override
  Widget pager(BuildContext context, PagerSpec spec) => _Pager(spec: spec);
}

class _ListPage extends StatelessWidget {
  const _ListPage({required this.spec});

  final ListPageSpec spec;

  @override
  Widget build(BuildContext context) {
    Widget fill(Widget child) =>
        SliverFillRemaining(hasScrollBody: false, child: child);
    return CustomScrollView(
      slivers: [
        if (spec.filters case final filters?)
          SliverToBoxAdapter(child: filters),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 2,
            child: spec.loading ? const LinearProgressIndicator() : null,
          ),
        ),
        if (spec.contentIsSliver) spec.content else fill(spec.content),
        // At the bottom of the window when the rows don't fill it.
        if (spec.pager case final pager?)
          fill(
            Align(alignment: AlignmentDirectional.bottomCenter, child: pager),
          ),
      ],
    );
  }
}

class _Pager extends StatelessWidget {
  const _Pager({required this.spec});

  final PagerSpec spec;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final kit = StellarKit.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.border)),
      ),
      child: Row(
        children: [
          for (final size in spec.pageSizes)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: Space.xs),
              child: kit.pill.render(
                context,
                PillSpec(
                  label: '$size',
                  selected: size == spec.pageSize,
                  onTap: () => spec.onPageSize(size),
                ),
              ),
            ),
          const Spacer(),
          Text(
            spec.pageLabel,
            style: TextStyle(color: c.textMuted, fontSize: 13),
          ),
          const Gap(Space.sm),
          IconButton(
            tooltip: spec.previousLabel,
            icon: Icon(
              materialIcon(SIcons.chevronBack),
              size: SIconSize.sm.pixels,
            ),
            onPressed: spec.onPrevious,
          ),
          IconButton(
            tooltip: spec.nextLabel,
            icon: Icon(materialIcon(SIcons.chevron), size: SIconSize.sm.pixels),
            onPressed: spec.onNext,
          ),
        ],
      ),
    );
  }
}
