import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_settings_renderer.dart';

/// Below this width the page list shows only icons.
const _compactBreakpoint = 720.0;
const _dialogWidth = 1000.0;
const _dialogMaxHeight = 680.0;
const _pageListWidth = 232.0;
const _compactPageListWidth = 60.0;

/// Below this width option cards go one to a row.
const _oneCardBreakpoint = 520.0;
const _previewHeight = 104.0;
const _cardRadius = 10.0;

/// Settings in the style of ERPNext's, as in the MIA portal.
class MaterialSettingsRenderer implements SettingsRenderer {
  const MaterialSettingsRenderer();

  @override
  Widget dialog(BuildContext context, SettingsDialogSpec spec) =>
      _SettingsDialog(spec: spec);

  @override
  Widget group(BuildContext context, SettingsGroupSpec spec) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          spec.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: c.text,
          ),
        ),
        const Gap(2),
        Text(spec.hint, style: TextStyle(fontSize: 13, color: c.textMuted)),
        const Gap(Space.md),
        spec.child,
      ],
    );
  }

  @override
  Widget optionGrid(BuildContext context, List<Widget> cards) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final perRow = width < _oneCardBreakpoint ? 1 : 3;
      final cardWidth = (width - Space.lg * (perRow - 1)) / perRow;
      return Wrap(
        spacing: Space.lg,
        runSpacing: Space.lg,
        children: [
          for (final card in cards) SizedBox(width: cardWidth, child: card),
        ],
      );
    },
  );

  @override
  Widget optionCard(BuildContext context, OptionCardSpec spec) {
    final c = context.colors;
    final radius = BorderRadius.circular(_cardRadius);
    return Semantics(
      selected: spec.selected,
      button: true,
      label: spec.label,
      excludeSemantics: true,
      child: Material(
        color: c.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: spec.selected ? c.text : c.border,
            width: spec.selected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: spec.onTap,
          hoverColor: c.primarySoft.withValues(alpha: 0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: _previewHeight,
                color: c.primarySoft,
                child: Directionality(
                  textDirection: spec.direction ?? Directionality.of(context),
                  // The window runs past the card's end and bottom edges.
                  child: Stack(
                    children: [
                      PositionedDirectional(
                        start: Space.lg,
                        top: 14,
                        end: -1,
                        bottom: -1,
                        child: switch (spec.preview) {
                          WindowPreview.light => const _Window(lightColors),
                          WindowPreview.dark => const _Window(darkColors),
                          WindowPreview.lightAndDark => const Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: Space.sm,
                            children: [
                              Expanded(child: _Window(lightColors)),
                              Expanded(child: _Window(darkColors)),
                            ],
                          ),
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: c.border),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: Space.md,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        spec.label,
                        style: TextStyle(fontSize: 14, color: c.text),
                      ),
                    ),
                    Icon(
                      materialIcon(
                        spec.selected ? SIcons.selected : SIcons.unselected,
                      ),
                      size: SIconSize.sm.pixels,
                      color: spec.selected ? c.text : c.textSubtle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsDialog extends StatefulWidget {
  const _SettingsDialog({required this.spec});

  final SettingsDialogSpec spec;

  @override
  State<_SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<_SettingsDialog> {
  var _open = 0;

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    final c = context.colors;
    final screen = MediaQuery.sizeOf(context);
    final compact = screen.width < _compactBreakpoint;
    return Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.all(Space.xl),
      backgroundColor: c.surface,
      child: SizedBox(
        width: _dialogWidth,
        height: (screen.height - Space.xl * 2).clamp(0, _dialogMaxHeight),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: compact ? _compactPageListWidth : _pageListWidth,
              color: c.surfaceMuted,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: Space.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 2,
                children: [
                  if (!compact)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        10,
                        0,
                        10,
                        Space.sm,
                      ),
                      child: Text(
                        spec.title,
                        style: TextStyle(fontSize: 13, color: c.textSubtle),
                      ),
                    ),
                  for (final (i, page) in spec.pages.indexed)
                    _PageItem(
                      page: page,
                      compact: compact,
                      selected: i == _open,
                      onTap: () => setState(() => _open = i),
                    ),
                ],
              ),
            ),
            VerticalDivider(width: 1, color: c.border),
            Expanded(
              // Pages stay alive while switching between them.
              child: IndexedStack(
                index: _open,
                children: [
                  for (final page in spec.pages) _PageBody(page: page),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A page in the list: highlighted like a raised card when open.
class _PageItem extends StatelessWidget {
  const _PageItem({
    required this.page,
    required this.compact,
    required this.selected,
    required this.onTap,
  });

  final SettingsPage page;
  final bool compact;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(Radii.md);
    final item = Material(
      color: selected ? c.surface : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: selected ? c.border : Colors.transparent),
      ),
      child: InkWell(
        borderRadius: radius,
        // The open page doesn't change on hover.
        hoverColor: selected ? c.surface : c.primarySoft,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: Space.sm,
          ),
          child: Row(
            mainAxisAlignment: compact
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            spacing: 10,
            children: [
              Icon(
                materialIcon(page.icon),
                size: SIconSize.xs.pixels,
                color: c.text,
              ),
              if (!compact)
                Expanded(
                  child: Text(
                    page.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: c.text),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      child: compact ? Tooltip(message: page.label, child: item) : item,
    );
  }
}

/// A settings page: its title and hint, then its settings, scrolling.
class _PageBody extends StatelessWidget {
  const _PageBody({required this.page});

  final SettingsPage page;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Space.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            page.label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: c.text,
            ),
          ),
          const Gap(Space.xs),
          Text(page.hint, style: TextStyle(fontSize: 14, color: c.textMuted)),
          const Gap(Space.xl),
          ...page.children,
        ],
      ),
    );
  }
}

/// A miniature of the app's window in [colors]: a title bar with the three
/// window dots, a side menu on the start side and a page of fields. Cut
/// off at the card's edges, like ERPNext's.
class _Window extends StatelessWidget {
  const _Window(this.colors);

  final StellarColors colors;

  @override
  Widget build(BuildContext context) {
    final line = colors.border;

    Widget bar(double width, double height) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: line,
        borderRadius: BorderRadius.circular(2),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: line),
        borderRadius: const BorderRadiusDirectional.only(
          topStart: Radius.circular(Radii.sm),
        ).resolve(Directionality.of(context)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The window dots are always on the left, as on a Mac.
          Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
              child: Row(
                spacing: 3,
                children: [
                  for (final dot in windowDotColors)
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: dot,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(height: 1, color: line),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 40,
                  color: colors.surfaceMuted,
                  padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [bar(22, 3), bar(18, 3), bar(24, 3)],
                  ),
                ),
                Container(width: 1, color: line),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        bar(44, 4),
                        for (var row = 0; row < 3; row++)
                          Row(
                            spacing: 8,
                            children: [
                              Expanded(child: bar(double.infinity, 7)),
                              Expanded(child: bar(double.infinity, 7)),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
