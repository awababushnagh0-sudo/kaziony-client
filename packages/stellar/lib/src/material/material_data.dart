import 'package:flutter/material.dart';

import '../components/app_icon.dart';
import '../kit/contracts.dart';
import '../kit/stellar_kit.dart';
import '../tokens/tokens.dart';
import 'icons.dart';

/// ERPNext-style lists: a pinned header in a rounded gray box, rows that
/// light up on hover, the total at the end of the header, and a pager.
class MaterialDataRenderer implements DataRenderer {
  const MaterialDataRenderer();

  @override
  Widget table<T>(BuildContext context, TableSpec<T> spec) =>
      _Table<T>(spec: spec);

  @override
  Widget listPage(BuildContext context, ListPageSpec spec) =>
      _ListPage(spec: spec);

  @override
  Widget pager(BuildContext context, PagerSpec spec) => _Pager(spec: spec);

  @override
  Widget badge(BuildContext context, String label, BadgeTone tone) {
    final c = context.colors;
    final (fg, bg) = switch (tone) {
      BadgeTone.success => (c.success, c.successSoft),
      BadgeTone.warning => (c.warning, c.warningSoft),
      BadgeTone.danger => (c.danger, c.dangerSoft),
      // A shade darker than a hovered row, so it stays visible there.
      BadgeTone.neutral => (c.textMuted, c.border),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        label,
        maxLines: 1,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }

  @override
  Widget pill(BuildContext context, PillSpec spec) {
    final c = context.colors;
    final fg = spec.selected ? c.onPrimary : c.textMuted;
    final content = Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: Space.md),
      decoration: BoxDecoration(
        color: spec.selected ? c.primary : c.fieldFill,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(spec.label, style: TextStyle(color: fg, fontSize: 13)),
          if (spec.icon != null) ...[
            const Gap(Space.xs),
            Icon(materialIcon(spec.icon!), size: 16, color: fg),
          ],
        ],
      ),
    );
    if (spec.onTap == null) return content;
    return Semantics(
      button: true,
      selected: spec.selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.md),
        onTap: spec.onTap,
        child: content,
      ),
    );
  }

  @override
  Widget searchField(BuildContext context, SearchFieldSpec spec) =>
      _SearchField(spec: spec);

  @override
  Widget cellText(
    BuildContext context,
    String text, {
    bool strong = false,
    bool ltr = false,
  }) {
    final c = context.colors;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textDirection: ltr ? TextDirection.ltr : null,
      // Left-to-right text still lines up with the page's start edge.
      textAlign: ltr
          ? (rtl ? TextAlign.right : TextAlign.left)
          : TextAlign.start,
      style: strong
          ? TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.text)
          : TextStyle(fontSize: 13, color: c.textMuted),
    );
  }
}

class _Table<T> extends StatelessWidget {
  const _Table({required this.spec});

  final TableSpec<T> spec;

  /// Space between the table and the page edge, and between a box's edge
  /// and its text.
  static const _outer = 16.0;
  static const _inner = 8.0;

  /// The gap between two columns; in the header it holds a dividing line.
  static const _gap = 13.0;

  /// The space at the end of the header for the total.
  static const _totalWidth = 96.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(Radii.md);
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final visible = [
          for (final column in spec.columns)
            if (constraints.crossAxisExtent >= column.minWidth) column,
        ];
        Widget row(
          Widget Function(TableColumn<T> column) cell, {
          bool dividers = false,
          Widget? end,
        }) => Row(
          children: [
            for (final (i, column) in visible.indexed) ...[
              if (i > 0)
                SizedBox(
                  width: _gap,
                  child: dividers
                      ? Center(
                          child: Container(
                            width: 1,
                            height: 16,
                            color: c.border,
                          ),
                        )
                      : null,
                ),
              Expanded(flex: column.flex, child: cell(column)),
            ],
            const SizedBox(width: _gap),
            // Each row keeps this space empty, so the columns line up.
            SizedBox(width: _totalWidth, child: end),
          ],
        );

        final header = row(
          (column) => Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              column.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: c.textSubtle,
              ),
            ),
          ),
          dividers: true,
          end: Text(
            spec.totalLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 12, color: c.textSubtle),
          ),
        );

        return SliverMainAxisGroup(
          slivers: [
            // Pinned, it hides the rows scrolling under it.
            PinnedHeaderSliver(
              child: ColoredBox(
                color: c.background,
                child: Container(
                  height: 36,
                  margin: const EdgeInsets.fromLTRB(_outer, 8, _outer, 4),
                  padding: const EdgeInsets.symmetric(horizontal: _inner),
                  decoration: BoxDecoration(
                    color: c.primarySoft,
                    borderRadius: radius,
                  ),
                  child: header,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(_outer, 0, _outer, 8),
              sliver: SliverList.separated(
                itemCount: spec.rows.length,
                separatorBuilder: (_, _) =>
                    Divider(indent: _inner, endIndent: _inner, color: c.border),
                itemBuilder: (context, index) {
                  final item = spec.rows[index];
                  final content = Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: _inner),
                    child: row((column) => column.cell(item)),
                  );
                  final onOpen = spec.onOpen;
                  if (onOpen == null) return content;
                  // Hover and press fill the same rounded box as the header.
                  return InkWell(
                    borderRadius: radius,
                    hoverColor: c.primarySoft,
                    highlightColor: c.primarySoft,
                    splashFactory: NoSplash.splashFactory,
                    onTap: () => onOpen(item),
                    child: content,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
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
              child: kit.data.pill(
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
            icon: Icon(materialIcon(AppIcon.chevronBack), size: 18),
            onPressed: spec.onPrevious,
          ),
          IconButton(
            tooltip: spec.nextLabel,
            icon: Icon(materialIcon(AppIcon.chevron), size: 18),
            onPressed: spec.onNext,
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField({required this.spec});

  final SearchFieldSpec spec;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final _controller = TextEditingController(
    text: widget.spec.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextField(
      controller: _controller,
      onChanged: widget.spec.onChanged,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: widget.spec.hint,
        prefixIcon: Icon(
          materialIcon(AppIcon.search),
          size: 16,
          color: c.textSubtle,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 36),
      ),
    );
  }
}
