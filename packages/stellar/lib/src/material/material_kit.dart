import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../components/app_icon.dart';
import '../kit/contracts.dart';
import '../kit/stellar_kit.dart';
import '../l10n/generated/stellar_localizations.dart';
import '../tokens/tokens.dart';
import 'icons.dart';
import 'material_data.dart';
import 'material_overlay.dart';
import 'material_shell.dart';

/// The default kit, built on Material widgets.
const materialKit = StellarKit(
  button: MaterialButtonRenderer(),
  textInput: MaterialTextInputRenderer(),
  scaffold: MaterialScaffoldRenderer(),
  text: MaterialTextRenderer(),
  card: MaterialCardRenderer(),
  listTile: MaterialListTileRenderer(),
  status: MaterialStatusRenderer(),
  snack: MaterialSnackRenderer(),
  shell: MaterialShellRenderer(),
  data: MaterialDataRenderer(),
  overlay: MaterialOverlayRenderer(),
);

class MaterialButtonRenderer implements ButtonRenderer {
  const MaterialButtonRenderer();

  @override
  Widget render(BuildContext context, ButtonSpec spec) {
    final colors = context.colors;
    final spinnerColor = switch (spec.variant) {
      ButtonVariant.primary => colors.onPrimary,
      ButtonVariant.danger => colors.onDanger,
      _ => colors.primary,
    };
    final Widget child = spec.loading
        ? SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: spinnerColor,
            ),
          )
        : Text(spec.label);
    final icon = spec.icon == null || spec.loading
        ? null
        : Icon(materialIcon(spec.icon!), size: 20);
    // While loading the button keeps its look but ignores taps.
    final onPressed = spec.loading ? () {} : spec.onPressed;

    final Widget button = switch (spec.variant) {
      ButtonVariant.primary =>
        icon == null
            ? FilledButton(onPressed: onPressed, child: child)
            : FilledButton.icon(onPressed: onPressed, icon: icon, label: child),
      ButtonVariant.danger => FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: colors.danger,
          foregroundColor: colors.onDanger,
        ),
        onPressed: onPressed,
        child: child,
      ),
      ButtonVariant.secondary =>
        icon == null
            ? OutlinedButton(onPressed: onPressed, child: child)
            : OutlinedButton.icon(
                onPressed: onPressed,
                icon: icon,
                label: child,
              ),
      ButtonVariant.text =>
        icon == null
            ? TextButton(onPressed: onPressed, child: child)
            : TextButton.icon(onPressed: onPressed, icon: icon, label: child),
    };
    final Widget guarded = AbsorbPointer(
      absorbing: spec.loading,
      child: button,
    );
    return spec.expand
        ? SizedBox(width: double.infinity, child: guarded)
        : guarded;
  }

  @override
  Widget icon(BuildContext context, IconButtonSpec spec) => IconButton(
    tooltip: spec.tooltip,
    onPressed: spec.onPressed,
    icon: Icon(materialIcon(spec.icon), size: 20),
  );
}

class MaterialTextInputRenderer implements TextInputRenderer {
  const MaterialTextInputRenderer();

  @override
  Widget render(BuildContext context, TextInputSpec spec) =>
      spec.kind == TextInputKind.password
      ? _PasswordInput(spec: spec)
      : _buildField(context, spec);

  @override
  Widget select<T>(BuildContext context, SelectInputSpec<T> spec) => _labelled(
    context,
    label: spec.label,
    required: spec.required,
    child: ReactiveDropdownField<T>(
      formControlName: spec.controlName,
      validationMessages: spec.validationMessages,
      isExpanded: true,
      borderRadius: BorderRadius.circular(Radii.md),
      dropdownColor: context.colors.surface,
      icon: Icon(
        materialIcon(AppIcon.chevronDown),
        size: 16,
        color: context.colors.textSubtle,
      ),
      hint: spec.hint == null ? null : Text(spec.hint!),
      style: Theme.of(context).textTheme.bodyLarge,
      items: [
        for (final option in spec.options)
          DropdownMenuItem(value: option.value, child: Text(option.label)),
      ],
    ),
  );
}

/// A label above a form control, with a red asterisk when [required], as
/// in ERPNext; [helper] is a quiet line under it.
Widget _labelled(
  BuildContext context, {
  required String label,
  required Widget child,
  bool required = false,
  String? helper,
}) {
  final c = context.colors;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      ExcludeSemantics(
        child: Text.rich(
          TextSpan(
            text: label,
            children: [
              if (required)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: c.danger),
                ),
            ],
          ),
          style: TextStyle(fontSize: 13, color: c.text),
        ),
      ),
      const Gap(6),
      Semantics(label: label, child: child),
      if (helper != null) ...[
        const Gap(Space.xs),
        Text(helper, style: TextStyle(fontSize: 12, color: c.textSubtle)),
      ],
    ],
  );
}

Widget _buildField(
  BuildContext context,
  TextInputSpec spec, {
  bool obscure = false,
  Widget? suffix,
}) {
  // Phone numbers, emails, links and passwords read left to right, even in
  // Arabic; they still start at the page's start edge (the right, in
  // Arabic), like every other field.
  final ltr = switch (spec.kind) {
    TextInputKind.phone ||
    TextInputKind.email ||
    TextInputKind.url ||
    TextInputKind.password => true,
    _ => false,
  };
  final rtlPage = Directionality.of(context) == TextDirection.rtl;
  final field = ReactiveTextField<String>(
    formControlName: spec.controlName,
    validationMessages: spec.validationMessages,
    obscureText: obscure,
    maxLength: spec.maxLength,
    maxLines: spec.kind == TextInputKind.multiline ? 4 : 1,
    autofillHints: spec.autofillHints,
    autofocus: spec.autofocus,
    textDirection: ltr ? TextDirection.ltr : null,
    textAlign: ltr
        ? (rtlPage ? TextAlign.right : TextAlign.left)
        : TextAlign.start,
    keyboardType: switch (spec.kind) {
      TextInputKind.phone => TextInputType.phone,
      TextInputKind.number => const TextInputType.numberWithOptions(
        decimal: true,
      ),
      TextInputKind.email => TextInputType.emailAddress,
      TextInputKind.url => TextInputType.url,
      TextInputKind.multiline => TextInputType.multiline,
      _ => TextInputType.text,
    },
    textInputAction: spec.kind == TextInputKind.multiline
        ? TextInputAction.newline
        : spec.isLast
        ? TextInputAction.done
        : TextInputAction.next,
    onSubmitted: spec.onSubmitted == null
        ? null
        : (_) => spec.onSubmitted!.call(),
    // Pressing Enter to submit keeps the cursor in the field, so the user
    // can fix a wrong password right away.
    onEditingComplete: spec.onSubmitted == null ? null : (_) {},
    decoration: InputDecoration(
      hintText: spec.hint,
      hintTextDirection: ltr ? TextDirection.ltr : null,
      suffixIcon: suffix,
      // As tall as the other fields despite the button.
      suffixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 20),
    ),
  );
  return _labelled(
    context,
    label: spec.label,
    required: spec.required,
    helper: spec.helper,
    child: field,
  );
}

class _PasswordInput extends StatefulWidget {
  const _PasswordInput({required this.spec});

  final TextInputSpec spec;

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  var _obscure = true;

  @override
  Widget build(BuildContext context) {
    final strings = StellarLocalizations.of(context);
    return _buildField(
      context,
      widget.spec,
      obscure: _obscure,
      suffix: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 28, height: 28),
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        tooltip: _obscure ? strings.showPassword : strings.hidePassword,
        icon: Icon(
          materialIcon(_obscure ? AppIcon.show : AppIcon.hide),
          size: 18,
          color: context.colors.textSubtle,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}

class MaterialScaffoldRenderer implements ScaffoldRenderer {
  const MaterialScaffoldRenderer();

  @override
  Widget render(BuildContext context, ScaffoldSpec spec) {
    Widget body = spec.body;
    if (spec.padded) {
      body = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.xl,
          vertical: Space.lg,
        ),
        child: body,
      );
    }
    if (spec.maxWidth != null) {
      body = Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: spec.maxWidth!),
          child: body,
        ),
      );
    }
    if (spec.centered) {
      // Centered when it fits, scrollable when it doesn't (small windows,
      // open keyboard).
      final content = body;
      body = LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: content),
          ),
        ),
      );
    } else if (spec.scrollable) {
      body = SingleChildScrollView(child: body);
    }

    // Inside a narrow dashboard shell, top-level pages open the side menu.
    final openMenu = ShellScope.maybeOf(context)?.openMenu;
    final canPop = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
    return Scaffold(
      appBar: spec.showAppBar
          ? AppBar(
              leading: openMenu != null && !canPop
                  ? IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                      icon: Icon(materialIcon(AppIcon.menu)),
                      onPressed: openMenu,
                    )
                  : null,
              title: spec.title == null ? null : Text(spec.title!),
              actions: [...spec.actions, const Gap(Space.sm)],
            )
          : null,
      body: SafeArea(child: body),
      bottomNavigationBar: spec.bottom == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Space.xl,
                  Space.sm,
                  Space.xl,
                  Space.lg,
                ),
                child: spec.bottom,
              ),
            ),
    );
  }
}

class MaterialTextRenderer implements TextRenderer {
  const MaterialTextRenderer();

  @override
  Widget icon(BuildContext context, AppIcon icon, TextTone tone, double size) =>
      Icon(materialIcon(icon), size: size, color: _toneColor(context, tone));

  @override
  Widget render(BuildContext context, TextSpec spec) {
    final theme = Theme.of(context).textTheme;
    final base = switch (spec.variant) {
      TextVariant.display => theme.headlineMedium,
      TextVariant.title => theme.titleLarge,
      TextVariant.subtitle => theme.titleMedium,
      TextVariant.body => theme.bodyLarge,
      TextVariant.caption => theme.bodySmall,
      TextVariant.label => theme.labelLarge,
    };
    final color = _toneColor(context, spec.tone);
    return Text(
      spec.text,
      textAlign: spec.align,
      maxLines: spec.maxLines,
      overflow: spec.maxLines == null ? null : TextOverflow.ellipsis,
      style: base?.copyWith(
        color: color,
        fontWeight: spec.bold || spec.variant == TextVariant.display
            ? FontWeight.w700
            : null,
      ),
    );
  }
}

Color _toneColor(BuildContext context, TextTone tone) {
  final colors = context.colors;
  return switch (tone) {
    TextTone.normal => colors.text,
    TextTone.muted => colors.textMuted,
    TextTone.primary => colors.primary,
    TextTone.danger => colors.danger,
    TextTone.success => colors.success,
    TextTone.onPrimary => colors.onPrimary,
  };
}

class MaterialCardRenderer implements CardRenderer {
  const MaterialCardRenderer();

  @override
  Widget render(BuildContext context, CardSpec spec) {
    final content = spec.padded
        ? Padding(padding: const EdgeInsets.all(Space.lg), child: spec.child)
        : spec.child;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: spec.onTap == null
          ? content
          : InkWell(onTap: spec.onTap, child: content),
    );
  }
}

class MaterialListTileRenderer implements ListTileRenderer {
  const MaterialListTileRenderer();

  @override
  Widget render(BuildContext context, ListTileSpec spec) {
    final colors = context.colors;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: Space.lg),
      leading: spec.icon == null
          ? null
          : CircleAvatar(
              backgroundColor: colors.primarySoft,
              foregroundColor: colors.primary,
              child: Icon(materialIcon(spec.icon!), size: 20),
            ),
      title: Text(spec.title),
      subtitle: spec.subtitle == null ? null : Text(spec.subtitle!),
      trailing: spec.trailing,
      onTap: spec.onTap,
    );
  }
}

class MaterialStatusRenderer implements StatusRenderer {
  const MaterialStatusRenderer();

  @override
  Widget loading(BuildContext context, {String? message}) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        if (message != null) ...[
          const Gap(Space.lg),
          Text(message, style: TextStyle(color: context.colors.textMuted)),
        ],
      ],
    ),
  );

  @override
  Widget error(BuildContext context, StatusSpec spec) =>
      _status(context, spec, context.colors.danger);

  @override
  Widget empty(BuildContext context, StatusSpec spec) =>
      _status(context, spec, context.colors.textMuted);

  Widget _status(BuildContext context, StatusSpec spec, Color iconColor) {
    final theme = Theme.of(context).textTheme;
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (spec.icon != null)
              Icon(materialIcon(spec.icon!), size: 48, color: iconColor),
            const Gap(Space.lg),
            Text(
              spec.title,
              textAlign: TextAlign.center,
              style: theme.titleMedium?.copyWith(color: colors.text),
            ),
            if (spec.message != null) ...[
              const Gap(Space.sm),
              Text(
                spec.message!,
                textAlign: TextAlign.center,
                style: theme.bodyMedium?.copyWith(color: colors.textMuted),
              ),
            ],
            if (spec.actionLabel != null && spec.onAction != null) ...[
              const Gap(Space.xl),
              OutlinedButton.icon(
                onPressed: spec.onAction,
                icon: Icon(materialIcon(AppIcon.refresh), size: 18),
                label: Text(spec.actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MaterialSnackRenderer implements SnackRenderer {
  const MaterialSnackRenderer();

  @override
  void show(BuildContext context, String message, SnackTone tone) {
    final colors = context.colors;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: switch (tone) {
            SnackTone.info => colors.text,
            SnackTone.success => colors.success,
            SnackTone.error => colors.danger,
          },
        ),
      );
  }
}
