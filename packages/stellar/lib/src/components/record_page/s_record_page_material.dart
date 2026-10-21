import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import 's_record_page_renderer.dart';

/// Narrower than this, the side panel moves above the tabs.
const _sidePanelBreakpoint = 760.0;
const _sidePanelWidth = 260.0;
const _pictureSize = 88.0;

class MaterialRecordPageRenderer implements RecordPageRenderer {
  const MaterialRecordPageRenderer();

  @override
  Widget render(BuildContext context, RecordPageSpec spec) =>
      _RecordPage(spec: spec);

  @override
  Widget profile(BuildContext context, RecordProfileSpec spec) {
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final initial = _Initial(title: spec.title);
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Radii.lg),
          child: SizedBox.square(
            dimension: _pictureSize,
            child: spec.imageUrl == null
                ? initial
                : Image.network(
                    spec.imageUrl!,
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
          spec.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: text.titleMedium,
        ),
        if (spec.subtitle case final subtitle?)
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

class _RecordPage extends StatefulWidget {
  const _RecordPage({required this.spec});

  final RecordPageSpec spec;

  @override
  State<_RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<_RecordPage> {
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    final c = context.colors;
    // The tabs can change between builds (data reloaded); stay in range.
    final selected = _selected.clamp(0, spec.tabs.length - 1);
    final tabBar = spec.tabs.length < 2
        ? null
        : _TabBar(
            labels: [for (final tab in spec.tabs) tab.label],
            selected: selected,
            onSelect: (index) => setState(() => _selected = index),
          );
    final content = Padding(
      padding: const EdgeInsets.all(Space.xl),
      child: spec.tabs[selected].child,
    );
    final sidePanel = spec.sidebar.isEmpty
        ? null
        : _SidePanel(sections: spec.sidebar);

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
                            ? FontWeight.w600
                            : FontWeight.w500,
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
