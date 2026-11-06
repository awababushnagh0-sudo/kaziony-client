import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon_material.dart';
import 's_nav_bar.dart';

const _barHeight = 64.0;

/// [SNavBar], a white bar like the big apps': the open tab's icon and name
/// in the brand color, the others gray.
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
    final c = context.colors;
    final banner = widget.banner;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          NavBarRoom(
            bottom: banner == null ? 0 : _bannerHeight,
            child: widget.body,
          ),
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
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
      bottomNavigationBar: _bar(context, c),
    );
  }

  Widget _bar(BuildContext context, StellarColors c) => DecoratedBox(
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: c.border)),
    ),
    child: NavigationBar(
      selectedIndex: widget.selected,
      onDestinationSelected: widget.onSelect,
      height: _barHeight,
      elevation: 0,
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: context.style.text.tiny,
          fontWeight: states.contains(WidgetState.selected)
              ? SFontWeight.bold.value
              : SFontWeight.medium.value,
          color: states.contains(WidgetState.selected)
              ? c.primary
              : c.textSubtle,
        ),
      ),
      destinations: [
        for (final item in widget.items)
          NavigationDestination(
            label: item.label,
            icon: _counted(
              item,
              c,
              Icon(
                materialIcon(item.icon),
                size: SIconSize.lg.pixels,
                color: c.textSubtle,
              ),
            ),
            selectedIcon: _counted(
              item,
              c,
              Icon(
                materialIcon(item.icon),
                size: SIconSize.lg.pixels,
                color: c.primary,
              ),
            ),
          ),
      ],
    ),
  );

  /// [icon] with the item's count over it, when it has one.
  Widget _counted(NavBarItem item, StellarColors c, Widget icon) => Badge(
    isLabelVisible: item.count > 0,
    label: Text('${item.count}'),
    backgroundColor: c.accent,
    textColor: c.onAccent,
    child: icon,
  );
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
