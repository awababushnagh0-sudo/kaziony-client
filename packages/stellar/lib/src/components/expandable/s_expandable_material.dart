import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration.dart';
import 's_box_head.dart';
import 's_expandable.dart';

/// How long the box takes to open or close.
const _turn = Duration(milliseconds: 250);

/// [SExpandable]: an outlined [Material] with an [InkWell] row; under a
/// line, [child] on a soft gray, unfolding as it fades in and folding as
/// it fades out (Material's [ExpansionTile] way, without its look).
class SExpandableMaterial extends StatefulWidget implements SExpandable {
  const SExpandableMaterial({
    required this.title,
    required this.child,
    this.subtitle,
    this.tag,
    this.icon,
    this.illustration,
    this.initiallyOpen = false,
    super.key,
  });

  final String title;
  final Widget child;
  final String? subtitle;
  final String? tag;
  final SIcons? icon;
  final Illustration? illustration;
  final bool initiallyOpen;

  @override
  State<SExpandableMaterial> createState() => _SExpandableMaterialState();
}

class _SExpandableMaterialState extends State<SExpandableMaterial>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: _turn,
    value: widget.initiallyOpen ? 1 : 0,
  );
  late final _unfold = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  bool get _open =>
      _controller.status == AnimationStatus.forward ||
      _controller.status == AnimationStatus.completed;

  void _toggle() {
    setState(() {});
    if (_open) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _unfold.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return BoxFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            expanded: _open,
            button: true,
            child: InkWell(
              onTap: _toggle,
              child: BoxHead(
                title: widget.title,
                subtitle: widget.subtitle,
                tag: widget.tag,
                icon: widget.icon,
                illustration: widget.illustration,
                end: RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(_unfold),
                  child: Icon(
                    materialIcon(SIcons.chevronDown),
                    size: SIconSize.md.pixels,
                    color: c.textMuted,
                  ),
                ),
              ),
            ),
          ),
          // Built only while it shows, so a closed box holds nothing that
          // screen readers or tests would find.
          AnimatedBuilder(
            animation: _unfold,
            builder: (context, child) => _controller.isDismissed
                ? const SizedBox.shrink()
                : ClipRect(
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      heightFactor: _unfold.value,
                      child: Opacity(opacity: _unfold.value, child: child),
                    ),
                  ),
            // A Material, not a plain fill: rows' ripples show on it.
            child: Material(
              color: c.surfaceMuted,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(height: 1, color: c.border),
                  widget.child,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
