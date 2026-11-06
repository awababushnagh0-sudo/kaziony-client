import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration.dart';
import 's_box_head.dart';
import 's_expandable.dart';

const _turn = Duration(milliseconds: 200);

/// [SExpandable]: an outlined [Material] with an [InkWell] row, the
/// [child] sliding open and shut under a line.
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

class _SExpandableMaterialState extends State<SExpandableMaterial> {
  late var _open = widget.initiallyOpen;

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
              onTap: () => setState(() => _open = !_open),
              child: BoxHead(
                title: widget.title,
                subtitle: widget.subtitle,
                tag: widget.tag,
                icon: widget.icon,
                illustration: widget.illustration,
                end: AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: _turn,
                  child: Icon(
                    materialIcon(SIcons.chevronDown),
                    size: SIconSize.sm.pixels,
                    color: c.textSubtle,
                  ),
                ),
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: _turn,
              curve: Curves.easeOut,
              alignment: AlignmentDirectional.topStart,
              child: _open
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Divider(height: 1, color: c.border),
                        widget.child,
                      ],
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}
