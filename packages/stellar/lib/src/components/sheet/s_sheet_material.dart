import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../button/s_button_material.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration.dart';
import '../list_tile/s_radio_group.dart';
import 's_sheet.dart';

/// On a phone with rounded corners, the sheet floats [_sheetMargin] in
/// from its edges: its foot curves alongside the screen's corners (62 on
/// the iPhones of the last few years), [_sheetMargin] tighter so the two
/// curves keep the same gap all the way round; its top, out in the page,
/// rounded like a card. Drawn as iOS draws the screen's corners (a
/// superellipse), or the curves wouldn't run together.
const _footRadius = 62.0 - _sheetMargin;
const _topRadius = 28.0;
const _sheetMargin = Space.sm;

/// On a phone with square corners, it rests on the bottom edge as before,
/// rounded only at the top.
const _restingRadius = 20.0;

/// The grabber, as on iOS: a short thin bar at the top, a quiet gray.
const _grabberWidth = 36.0;
const _grabberHeight = 5.0;
const _grabberTop = Space.md;
const _grabberOpacity = 0.5;

/// Where the content starts: a clear gap under the grabber, so the title
/// doesn't crowd it.
const _contentTop = _grabberTop + _grabberHeight + Space.xl;

/// The close button, a circle of glass as on iOS, sits in the top end
/// corner beside the grabber, its top level with the grabber's and as far
/// in from the side.
const _closeInset = _grabberTop;

/// How far the title keeps from each side so a long one never runs under
/// the close button (on both sides, so it stays centered).
const _titleInset =
    _closeInset + SGlassButtonMaterial.size + Space.sm - Space.lg;

/// [SSheet]: a white card floating over the page's foot, a grabber and a close
/// button: an optional picture, the title and a line on what the choice
/// changes, then the choices as an [SRadioGroup], or the ways forward as
/// outlined rows. Tapping one closes the sheet with it.
abstract final class SSheetMaterial {
  static Future<T?> choose<T>(
    BuildContext context, {
    required String title,
    required List<RadioOption<T>> options,
    T? selected,
    String? subtitle,
    Illustration? illustration,
  }) => _show(
    context,
    (_) => _ChoiceSheet(
      title: title,
      options: options,
      selected: selected,
      subtitle: subtitle,
      illustration: illustration,
    ),
  );

  static Future<T?> actions<T>(
    BuildContext context, {
    required String title,
    required List<SheetAction<T>> actions,
    String? subtitle,
  }) => _show(
    context,
    (_) => _ActionSheet(title: title, actions: actions, subtitle: subtitle),
  );

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required WidgetBuilder builder,
    String? subtitle,
    Illustration? illustration,
  }) => _show(
    context,
    (_) => _ContentSheet(
      title: title,
      subtitle: subtitle,
      illustration: illustration,
      builder: builder,
    ),
  );

  static Future<T?> _show<T>(BuildContext context, WidgetBuilder builder) =>
      showModalBottomSheet<T>(
        context: context,
        // Over the whole app: a tab's own navigator would put it under
        // the nav bar.
        useRootNavigator: true,
        useSafeArea: true,
        // Long lists (a store's branches) scroll inside the sheet.
        isScrollControlled: true,
        // The sheet draws its own card, inset from the screen's edges.
        backgroundColor: Colors.transparent,
        elevation: 0,
        builder: (context) => _Floating(child: _Frame(child: builder(context))),
      );
}

/// The sheet as a card off the screen's sides and bottom on a phone with
/// rounded corners (one with a home bar), resting on its edge otherwise;
/// above the keyboard either way when its content has a field.
class _Floating extends StatelessWidget {
  const _Floating({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    // The home bar's room stays while the keyboard is up; the padding
    // under it doesn't.
    final floats = media.viewPadding.bottom > 0;
    final margin = floats ? _sheetMargin : 0.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        margin,
        0,
        margin,
        margin + media.viewInsets.bottom,
      ),
      child: MediaQuery(
        data: media.copyWith(
          // Floating, the gap under the card takes part of the home bar's
          // room; the content keeps half of the rest, enough to end just
          // past the home bar without a tall empty foot.
          padding: floats
              ? media.padding.copyWith(
                  bottom:
                      (media.padding.bottom - _sheetMargin).clamp(
                        0,
                        double.infinity,
                      ) /
                      2,
                )
              : media.padding,
          viewInsets: media.viewInsets.copyWith(bottom: 0),
        ),
        child: Material(
          color: context.colors.surface,
          shape: floats
              ? const RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(_topRadius),
                    bottom: Radius.circular(_footRadius),
                  ),
                )
              : const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(_restingRadius),
                  ),
                ),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      ),
    );
  }
}

/// What every sheet has around its content: the grabber at the top and
/// the close button in the top end corner.
class _Frame extends StatelessWidget {
  const _Frame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: _contentTop),
          child: child,
        ),
        PositionedDirectional(
          top: _grabberTop,
          start: 0,
          end: 0,
          child: Center(
            child: Container(
              width: _grabberWidth,
              height: _grabberHeight,
              decoration: BoxDecoration(
                color: c.textSubtle.withValues(alpha: _grabberOpacity),
                borderRadius: BorderRadius.circular(Radii.pill),
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: _grabberTop,
          end: _closeInset,
          child: SGlassButtonMaterial(
            icon: SIcons.close,
            tooltip: StellarLocalizations.of(context).close,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}

/// The picture, the title and its line, centered, as every sheet starts.
class _Heading extends StatelessWidget {
  const _Heading({required this.title, this.subtitle, this.illustration});

  final String title;
  final String? subtitle;
  final Illustration? illustration;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (illustration case final illustration?) ...[
          SIllustration(illustration),
          const Gap(Space.md),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _titleInset),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: text.title,
              fontWeight: SFontWeight.bold.value,
              color: c.text,
            ),
          ),
        ),
        if (subtitle case final subtitle?) ...[
          const Gap(Space.xs),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: text.body, color: c.textMuted),
          ),
        ],
      ],
    );
  }
}

/// The safe area keeps the top and sides; the bottom (the home indicator)
/// is left to the sheet. The top is the frame's.
EdgeInsets _sheetPadding(BuildContext context) => EdgeInsets.fromLTRB(
  Space.lg,
  0,
  Space.lg,
  Space.lg + MediaQuery.paddingOf(context).bottom,
);

class _ActionSheet<T> extends StatelessWidget {
  const _ActionSheet({
    required this.title,
    required this.actions,
    this.subtitle,
  });

  final String title;
  final List<SheetAction<T>> actions;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Padding(
    padding: _sheetPadding(context),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Heading(title: title, subtitle: subtitle),
        const Gap(Space.xl),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.sm,
          children: [
            for (final action in actions)
              _ActionRow(
                action: action,
                onTap: () => Navigator.of(context).pop(action.value),
              ),
          ],
        ),
      ],
    ),
  );
}

/// A way forward: an outlined row with its icon, its label in bold, where
/// it leads, and an arrow.
class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.action, required this.onTap});

  final SheetAction<Object?> action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final hint = action.hint;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.xl),
        side: BorderSide(color: c.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.lg,
            vertical: Space.md,
          ),
          child: Row(
            spacing: Space.md,
            children: [
              Icon(
                materialIcon(action.icon),
                size: SIconSize.md.pixels,
                color: c.text,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Space.xxs,
                  children: [
                    Text(
                      action.label,
                      style: TextStyle(
                        fontSize: text.subtitle,
                        fontWeight: SFontWeight.bold.value,
                        color: c.text,
                      ),
                    ),
                    if (hint != null)
                      Text(
                        hint,
                        style: TextStyle(
                          fontSize: text.small,
                          color: c.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                materialIcon(SIcons.chevron),
                size: SIconSize.sm.pixels,
                color: c.textSubtle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceSheet<T> extends StatelessWidget {
  const _ChoiceSheet({
    required this.title,
    required this.options,
    required this.selected,
    this.subtitle,
    this.illustration,
  });

  final String title;
  final List<RadioOption<T>> options;

  /// The current choice, marked with a check.
  final T? selected;
  final String? subtitle;
  final Illustration? illustration;

  @override
  Widget build(BuildContext context) => Padding(
    padding: _sheetPadding(context),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Heading(title: title, subtitle: subtitle, illustration: illustration),
        const Gap(Space.xl),
        Flexible(
          child: SingleChildScrollView(
            child: SRadioGroup<T>(
              options: options,
              value: selected,
              onChanged: (value) => Navigator.of(context).pop(value),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ContentSheet extends StatelessWidget {
  const _ContentSheet({
    required this.title,
    required this.builder,
    this.subtitle,
    this.illustration,
  });

  final String title;
  final String? subtitle;
  final Illustration? illustration;

  /// Built in the sheet's context, so it can close the sheet.
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => Padding(
    padding: _sheetPadding(context),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Heading(title: title, subtitle: subtitle, illustration: illustration),
        const Gap(Space.xl),
        Flexible(
          child: SingleChildScrollView(child: Builder(builder: builder)),
        ),
      ],
    ),
  );
}
