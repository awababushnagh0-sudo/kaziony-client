import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_record_page.dart';

/// Narrower than this, the side panel moves above the tabs.
const _sidePanelBreakpoint = 760.0;
const _sidePanelWidth = 260.0;
const _pictureSize = 88.0;

/// [SRecordProfile]: the picture with rounded corners over the centered
/// name.
class SRecordProfileMaterial extends StatelessWidget implements SRecordProfile {
  const SRecordProfileMaterial({
    required this.title,
    this.subtitle,
    this.imageUrl,
    super.key,
  });

  final String title;
  final String? subtitle;

  /// Without one (or when it fails to load), the title's first letter.
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final initial = _Initial(title: title);
    final imageUrl = this.imageUrl;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Radii.lg),
          child: SizedBox.square(
            dimension: _pictureSize,
            child: imageUrl == null
                ? initial
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    // Uploaded pictures live on another host; let the
                    // browser show them when it won't hand over the bytes.
                    webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
                    errorBuilder: (_, _, _) => initial,
                  ),
          ),
        ),
        const Gap(Space.md),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: text.titleMedium,
        ),
        if (subtitle case final subtitle?)
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(color: c.textSubtle),
          ),
      ],
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final letter = title.trim().characters.firstOrNull ?? '';
    return ColoredBox(
      color: c.fieldFill,
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(color: c.textMuted),
        ),
      ),
    );
  }
}

/// [SRecordPage] as ERPNext's form view: tabs of fields, and a side panel
/// with the record's picture and key facts.
class SRecordPageMaterial extends StatefulWidget implements SRecordPage {
  const SRecordPageMaterial({
    required this.tabs,
    this.sidebar = const [],
    super.key,
  });

  /// The bar is hidden when there is only one.
  final List<RecordTab> tabs;

  /// Sections of the side panel, separated by lines.
  final List<Widget> sidebar;

  @override
  State<SRecordPageMaterial> createState() => _RecordPageState();
}

class _RecordPageState extends State<SRecordPageMaterial> {
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = widget.tabs;
    final sidebar = widget.sidebar;
    final c = context.colors;
    // The tabs can change between builds (data reloaded); stay in range.
    final selected = _selected.clamp(0, tabs.length - 1);
    final tabBar = tabs.length < 2
        ? null
        : _TabBar(
            labels: [for (final tab in tabs) tab.label],
            selected: selected,
            onSelect: (index) => setState(() => _selected = index),
          );
    final content = Padding(
      padding: const EdgeInsets.all(Space.xl),
      // A fresh subtree per tab: fields in the same spot on two tabs must not
      // share their state (a text field would keep the other one's text).
      child: KeyedSubtree(key: ValueKey(selected), child: tabs[selected].child),
    );
    final sidePanel = sidebar.isEmpty ? null : _SidePanel(sections: sidebar);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _sidePanelBreakpoint) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (sidePanel != null) ...[sidePanel, const Divider()],
                ?tabBar,
                content,
              ],
            ),
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ?tabBar,
                  Expanded(child: SingleChildScrollView(child: content)),
                ],
              ),
            ),
            if (sidePanel != null) ...[
              VerticalDivider(width: 1, color: c.border),
              SizedBox(
                width: _sidePanelWidth,
                child: SingleChildScrollView(child: sidePanel),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// ERPNext's form tabs: plain labels on a line, the open one underlined.
class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.labels,
    required this.selected,
    required this.onSelect,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = Theme.of(context).textTheme.bodyMedium;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      // The first label lines up with the fields below (sm + lg = xl).
      padding: const EdgeInsets.symmetric(horizontal: Space.sm),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final (i, label) in labels.indexed)
              Semantics(
                button: true,
                selected: i == selected,
                child: InkWell(
                  onTap: () => onSelect(i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Space.lg,
                      vertical: Space.md,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: i == selected ? c.text : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      label,
                      style: style?.copyWith(
                        height: 1.2,
                        color: i == selected ? c.text : c.textMuted,
                        fontWeight: i == selected
                            ? SFontWeight.semibold.value
                            : SFontWeight.medium.value,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  const _SidePanel({required this.sections});

  final List<Widget> sections;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (i, section) in sections.indexed) ...[
        if (i > 0) const Divider(),
        Padding(padding: const EdgeInsets.all(Space.lg), child: section),
      ],
    ],
  );
}
