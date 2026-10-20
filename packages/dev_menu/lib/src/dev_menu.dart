import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';

import 'dev_panel.dart';

/// Adds a draggable bug button in dev and staging builds. Tapping it opens
/// the dev menu over the app. In production builds this is just [child]
/// (the rest is compiled out, since [kDevTools] is a constant).
class DevMenu extends StatefulWidget {
  const DevMenu({required this.child, super.key});

  final Widget child;

  @override
  State<DevMenu> createState() => _DevMenuState();
}

class _DevMenuState extends State<DevMenu> {
  static const _size = 44.0;

  var _open = false;
  Offset? _position;

  @override
  Widget build(BuildContext context) {
    if (!kDevTools) return widget.child;

    final screen = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final position =
        _position ?? Offset(12, screen.height - padding.bottom - 140);

    return Stack(
      children: [
        widget.child,
        if (_open)
          Positioned.fill(
            child: DevPanel(onClose: () => setState(() => _open = false)),
          )
        else
          Positioned(
            left: position.dx,
            top: position.dy,
            child: GestureDetector(
              onTap: () => setState(() => _open = true),
              onPanUpdate: (details) => setState(() {
                final next = position + details.delta;
                _position = Offset(
                  next.dx.clamp(0, screen.width - _size),
                  next.dy.clamp(padding.top, screen.height - _size),
                );
              }),
              child: _Bubble(env: appEnv),
            ),
          ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.env});

  final AppEnv env;

  @override
  Widget build(BuildContext context) => Material(
    color: env == AppEnv.staging
        ? Colors.deepPurple.withValues(alpha: 0.85)
        : Colors.black.withValues(alpha: 0.7),
    shape: const CircleBorder(),
    elevation: 4,
    child: const SizedBox.square(
      dimension: _DevMenuState._size,
      child: Icon(Icons.bug_report_outlined, color: Colors.white, size: 22),
    ),
  );
}
