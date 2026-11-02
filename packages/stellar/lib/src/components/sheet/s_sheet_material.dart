import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration.dart';
import '../list_tile/s_radio_group.dart';
import 's_sheet_renderer.dart';

const _sheetRadius = 20.0;

/// A white sheet with rounded top corners and a handle: an optional
/// picture, the title and a line on what the choice changes, then the
/// choices as an [SRadioGroup], or the ways forward as outlined rows.
/// Tapping one closes the sheet with it.
class MaterialSheetRenderer implements SheetRenderer {
  const MaterialSheetRenderer();

  @override
  Future<T?> choose<T>(BuildContext context, ChoiceSheetSpec<T> spec) =>
      _show(context, (_) => _ChoiceSheet(spec: spec));

  @override
  Future<T?> actions<T>(BuildContext context, ActionSheetSpec<T> spec) =>
      _show(context, (_) => _ActionSheet(spec: spec));

  @override
  Future<T?> content<T>(BuildContext context, ContentSheetSpec spec) =>
      _show(context, (_) => _ContentSheet(spec: spec));

  Future<T?> _show<T>(BuildContext context, WidgetBuilder builder) =>
      showModalBottomSheet<T>(
        context: context,
        // Over the whole app: a tab's own navigator would put it under
        // the nav bar.
        useRootNavigator: true,
        useSafeArea: true,
        showDragHandle: true,
        // Long lists (a store's branches) scroll inside the sheet.
        isScrollControlled: true,
        backgroundColor: context.colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_sheetRadius),
          ),
        ),
        builder: builder,
      );
}

/// The title and its line, centered, as both sheets start.
class _Heading extends StatelessWidget {
  const _Heading({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: text.title,
            fontWeight: SFontWeight.bold.value,
            color: c.text,
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
/// is left to the sheet.
EdgeInsets _sheetPadding(BuildContext context) => EdgeInsets.fromLTRB(
  Space.lg,
  0,
  Space.lg,
  Space.lg + MediaQuery.paddingOf(context).bottom,
);

class _ActionSheet<T> extends StatelessWidget {
  const _ActionSheet({required this.spec});

  final ActionSheetSpec<T> spec;

  @override
  Widget build(BuildContext context) => Padding(
    padding: _sheetPadding(context),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Heading(title: spec.title, subtitle: spec.subtitle),
        const Gap(Space.xl),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.sm,
          children: [
            for (final action in spec.actions)
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
  const _ChoiceSheet({required this.spec});

  final ChoiceSheetSpec<T> spec;

  @override
  Widget build(BuildContext context) => Padding(
    padding: _sheetPadding(context),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (spec.illustration case final illustration?) ...[
          SIllustration(illustration),
          const Gap(Space.md),
        ],
        _Heading(title: spec.title, subtitle: spec.subtitle),
        const Gap(Space.xl),
        Flexible(
          child: SingleChildScrollView(
            child: SRadioGroup<T>(
              options: spec.options,
              value: spec.selected,
              onChanged: (value) => Navigator.of(context).pop(value),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ContentSheet extends StatelessWidget {
  const _ContentSheet({required this.spec});

  final ContentSheetSpec spec;

  @override
  Widget build(BuildContext context) => Padding(
    // Above the keyboard when the content has a field.
    padding: _sheetPadding(context)
        .add(EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Heading(title: spec.title, subtitle: spec.subtitle),
        const Gap(Space.xl),
        Flexible(
          child: SingleChildScrollView(child: Builder(builder: spec.builder)),
        ),
      ],
    ),
  );
}
