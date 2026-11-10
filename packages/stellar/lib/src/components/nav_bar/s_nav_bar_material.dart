import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../material/s_glass.dart';
import '../icon/s_icon_material.dart';
import 's_nav_bar.dart';

/// [SNavBar], a pill of glass floating over the page's foot like the big
/// apps': the page scrolls on under it, the open tab's icon and name in the
/// brand color on a shade of the glass that slides to the tab tapped, as
/// on Apple's.
class SNavBarMaterial extends StatefulWidget implements SNavBar {
  const SNavBarMaterial({
    required this.items,
    required this.selected,
    required this.onSelect,
    required this.body,
    this.banner,
    super.key,
  });

  final List<NavBarItem> items;
  final int selected;
  final ValueChanged<int> onSelect;
  final Widget body;
  final Widget? banner;

  @override
  State<SNavBarMaterial> createState() => _SNavBarMaterialState();
}

class _SNavBarMaterialState extends State<SNavBarMaterial> {
  static const _barHeight = 64.0;
  static const _slide = Duration(milliseconds: 250);

  /// How tall the banner is with its margin, once laid out.
  double _bannerHeight = 0;

  void _measured(double height) {
    if (mounted && height != _bannerHeight) {
      setState(() => _bannerHeight = height);
    }
  }

  @override
  Widget build(BuildContext context) {
    final banner = widget.banner;
    // Just above the phone's home bar, as the big apps sit theirs, and off
    // the screen's edge on phones without one. The view's padding, not the
    // padding left, so the bar stays put while the keyboard is up.
    final lift = math.max(
      MediaQuery.viewPaddingOf(context).bottom - Space.xs,
      Space.md,
    );
    final barRoom = _barHeight + lift;
    return Scaffold(
      // The page goes on under the bar, for the glass to show it; snacks
      // still come up above the bar.
      extendBody: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          NavBarRoom(
            bottom: barRoom + (banner == null ? 0 : _bannerHeight),
            // The room under the bar is handed on as NavBarRoom instead,
            // so the page fills the screen rather than stopping above it.
            // From inside the Scaffold, which has already made room for
            // the keyboard: the page mustn't make it again.
            child: Builder(
              builder: (context) => MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: widget.body,
              ),
            ),
          ),
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: barRoom,
            child: AnimatedSwitcher(
              duration: _slide,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: banner == null
                  ? const SizedBox(width: double.infinity)
                  : _Measured(
                      onHeight: _measured,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          Space.lg,
                          0,
                          Space.lg,
                          Space.md,
                        ),
                        child: banner,
                      ),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, lift),
        child: SizedBox(
          height: _barHeight,
          child: _Tabs(
            items: widget.items,
            selected: widget.selected,
            onSelect: widget.onSelect,
            slide: _slide,
          ),
        ),
      ),
    );
  }
}

/// The tabs on their glass, the open one on a shade of it.
class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.items,
    required this.selected,
    required this.onSelect,
    required this.slide,
  });

  final List<NavBarItem> items;
  final int selected;
  final ValueChanged<int> onSelect;
  final Duration slide;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final count = items.length;
    return SGlass(
      shape: SGlassShape.pill,
      child: Padding(
        padding: const EdgeInsets.all(Space.xs),
        child: Stack(
          children: [
            // Under the open tab, from start to end in either language.
            AnimatedAlign(
              alignment: AlignmentDirectional(
                count == 1 ? 0 : -1 + 2 * selected / (count - 1),
                0,
              ),
              duration: slide,
              curve: Curves.easeOutCubic,
              child: FractionallySizedBox(
                widthFactor: 1 / count,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: c.glassSelected,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                for (final (i, item) in items.indexed)
                  Expanded(
                    child: _Tab(
                      item: item,
                      selected: i == selected,
                      onTap: () => onSelect(i),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One tab: its icon, with the count over it when there's one, over its
/// name.
class _Tab extends StatelessWidget {
  const _Tab({required this.item, required this.selected, required this.onTap});

  final NavBarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = selected ? c.primary : c.textMuted;
    return Semantics(
      button: true,
      selected: selected,
      // No ripple: the shade sliding over is the answer to a tap, as on
      // Apple's.
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Space.xxs,
          children: [
            Badge(
              isLabelVisible: item.count > 0,
              label: Text('${item.count}'),
              backgroundColor: c.accent,
              textColor: c.onAccent,
              child: Icon(
                materialIcon(item.icon),
                size: SIconSize.lg.pixels,
                color: color,
              ),
            ),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: context.style.text.tiny,
                fontWeight: selected
                    ? SFontWeight.bold.value
                    : SFontWeight.medium.value,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// How much of the page's foot the banner covers, for the page's lists to
/// keep room at their end (SScaffold hands it on as bottom padding).
class NavBarRoom extends InheritedWidget {
  const NavBarRoom({required this.bottom, required super.child, super.key});

  final double bottom;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavBarRoom>()?.bottom ?? 0;

  @override
  bool updateShouldNotify(NavBarRoom old) => old.bottom != bottom;
}

/// Tells [onHeight] its child's height after each layout that changes it.
class _Measured extends SingleChildRenderObjectWidget {
  const _Measured({required this.onHeight, required super.child});

  final ValueChanged<double> onHeight;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasured(onHeight);

  @override
  void updateRenderObject(BuildContext context, _RenderMeasured renderObject) =>
      renderObject.onHeight = onHeight;
}

class _RenderMeasured extends RenderProxyBox {
  _RenderMeasured(this.onHeight);

  ValueChanged<double> onHeight;
  double? _told;

  @override
  void performLayout() {
    super.performLayout();
    final height = size.height;
    if (height == _told) return;
    _told = height;
    // Not during layout: the page rebuilds with the room.
    WidgetsBinding.instance.addPostFrameCallback((_) => onHeight(height));
  }
}
