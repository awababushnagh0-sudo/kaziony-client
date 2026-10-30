import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_confirmation_renderer.dart';

class MaterialConfirmationRenderer implements ConfirmationRenderer {
  const MaterialConfirmationRenderer();

  @override
  Widget page(BuildContext context, ConfirmationSpec spec) {
    final c = context.colors;
    final text = context.style.text;
    final label = spec.label;
    final amount = spec.amount;
    final note = spec.note;
    final icon = spec.actionIcon;
    final onGreen = c.brightness == Brightness.light
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: onGreen,
      child: Scaffold(
        backgroundColor: c.primary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const _Tick(),
                          const Gap(Space.xxl + Space.lg),
                          Semantics(
                            header: true,
                            liveRegion: true,
                            child: Text(
                              spec.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: text.display,
                                fontWeight: SFontWeight.bold.value,
                                color: c.onPrimary,
                              ),
                            ),
                          ),
                          if (label != null) ...[
                            const Gap(Space.sm),
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: text.subtitle,
                                color: c.onPrimaryMuted,
                              ),
                            ),
                          ],
                          if (amount != null)
                            Text(
                              amount,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: text.hero,
                                fontWeight: SFontWeight.bold.value,
                                color: c.onPrimary,
                              ),
                            ),
                          if (note != null) ...[
                            const Gap(Space.lg),
                            Text(
                              note,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: text.small,
                                color: c.onPrimaryMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: spec.onAction,
                  // The light button of the green page.
                  style: FilledButton.styleFrom(
                    backgroundColor: c.onPrimary,
                    foregroundColor: c.primary,
                  ),
                  icon: icon == null
                      ? null
                      : Icon(materialIcon(icon), size: SIconSize.md.pixels),
                  label: Text(spec.actionLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A big tick in a light circle with soft rings, popping in.
class _Tick extends StatelessWidget {
  const _Tick();

  static const _size = 112.0;
  static const _inner = 16.0;
  static const _outer = 34.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      builder: (context, scale, child) => Opacity(
        opacity: ((scale - 0.6) / 0.4).clamp(0, 1),
        child: Transform.scale(scale: scale, child: child),
      ),
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: c.onPrimary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: c.onPrimary.withValues(alpha: 0.12),
              spreadRadius: _inner,
            ),
            BoxShadow(
              color: c.onPrimary.withValues(alpha: 0.06),
              spreadRadius: _outer,
            ),
          ],
        ),
        child: Icon(
          materialIcon(SIcons.check),
          size: SIconSize.xl.pixels,
          color: c.primary,
        ),
      ),
    );
  }
}
