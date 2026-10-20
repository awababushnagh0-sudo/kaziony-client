import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../components/app_icon.dart';
import '../kit/contracts.dart';
import '../kit/stellar_kit.dart';
import '../l10n/generated/stellar_localizations.dart';
import '../tokens/tokens.dart';

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
);

IconData materialIcon(AppIcon icon) => switch (icon) {
  AppIcon.store => Icons.storefront_outlined,
  AppIcon.location => Icons.place_outlined,
  AppIcon.logout => Icons.logout,
  AppIcon.language => Icons.translate,
  AppIcon.lock => Icons.lock_outline,
  AppIcon.refresh => Icons.refresh,
  AppIcon.noConnection => Icons.wifi_off_rounded,
  AppIcon.error => Icons.error_outline,
  AppIcon.empty => Icons.inbox_outlined,
  AppIcon.update => Icons.system_update_outlined,
  AppIcon.check => Icons.check_circle_outline,
  AppIcon.chevron => Icons.chevron_right,
};

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
}

class MaterialTextInputRenderer implements TextInputRenderer {
  const MaterialTextInputRenderer();

  @override
  Widget render(BuildContext context, TextInputSpec spec) =>
      spec.kind == TextInputKind.password
      ? _PasswordInput(spec: spec)
      : _buildField(context, spec);
}

Widget _buildField(
  BuildContext context,
  TextInputSpec spec, {
  bool obscure = false,
  Widget? suffix,
}) {
  final isPhone = spec.kind == TextInputKind.phone;
  return ReactiveTextField<String>(
    formControlName: spec.controlName,
    validationMessages: spec.validationMessages,
    obscureText: obscure,
    maxLength: spec.maxLength,
    maxLines: spec.kind == TextInputKind.multiline ? 4 : 1,
    autofillHints: spec.autofillHints,
    // Phone numbers and emails read left to right, even in Arabic.
    textDirection: isPhone || spec.kind == TextInputKind.email
        ? TextDirection.ltr
        : null,
    keyboardType: switch (spec.kind) {
      TextInputKind.phone => TextInputType.phone,
      TextInputKind.number => const TextInputType.numberWithOptions(
        decimal: true,
      ),
      TextInputKind.email => TextInputType.emailAddress,
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
    decoration: InputDecoration(
      labelText: spec.label,
      hintText: spec.hint,
      hintTextDirection: isPhone ? TextDirection.ltr : null,
      suffixIcon: suffix,
    ),
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
        tooltip: _obscure ? strings.showPassword : strings.hidePassword,
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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
    if (spec.scrollable) body = SingleChildScrollView(child: body);
    return Scaffold(
      appBar: spec.showAppBar
          ? AppBar(
              title: spec.title == null ? null : Text(spec.title!),
              actions: spec.actions,
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
  Widget render(BuildContext context, TextSpec spec) {
    final theme = Theme.of(context).textTheme;
    final colors = context.colors;
    final base = switch (spec.variant) {
      TextVariant.display => theme.headlineMedium,
      TextVariant.title => theme.titleLarge,
      TextVariant.subtitle => theme.titleMedium,
      TextVariant.body => theme.bodyLarge,
      TextVariant.caption => theme.bodySmall,
      TextVariant.label => theme.labelLarge,
    };
    final color = switch (spec.tone) {
      TextTone.normal => colors.text,
      TextTone.muted => colors.textMuted,
      TextTone.primary => colors.primary,
      TextTone.danger => colors.danger,
      TextTone.success => colors.success,
      TextTone.onPrimary => colors.onPrimary,
    };
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
                icon: const Icon(Icons.refresh),
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
