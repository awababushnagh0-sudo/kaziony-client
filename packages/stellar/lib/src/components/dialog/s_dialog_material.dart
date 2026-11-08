import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../button/s_button_material.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_dialog.dart';

/// [SDialog] in the style of ERPNext, drawn with Material's [Dialog].
class SDialogMaterial extends StatelessWidget implements SDialog {
  const SDialogMaterial({
    required this.title,
    required this.body,
    this.primaryLabel,
    this.onPrimary,
    this.busy = false,
    this.showCancel = true,
    this.width = 520,
    super.key,
  });

  final String title;
  final Widget body;

  /// The main button; no footer without it.
  final String? primaryLabel;
  final VoidCallback? onPrimary;

  /// Disables the buttons and closing while the action runs.
  final bool busy;
  final bool showCancel;
  final double width;

  /// [SDialog.show].
  static Future<T?> show<T>(
    BuildContext context,
    WidgetBuilder builder, {
    bool dismissible = true,
  }) => showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    builder: builder,
  );

  /// [SDialog.confirm]: on the phones, the question centered over the
  /// action and the way back, one under the other and full width (a
  /// destructive action soft red, never a loud one); on the dashboard,
  /// Material's [AlertDialog].
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
    bool destructive = false,
  }) async {
    final cancel = cancelLabel ?? StellarLocalizations.of(context).cancel;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => context.style == StellarStyle.app
          ? _PhoneConfirm(
              title: title,
              message: message,
              confirmLabel: confirmLabel,
              cancelLabel: cancel,
              destructive: destructive,
            )
          : _DashboardConfirm(
              title: title,
              message: message,
              confirmLabel: confirmLabel,
              cancelLabel: cancel,
              destructive: destructive,
            ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final strings = StellarLocalizations.of(context);
    final primaryLabel = this.primaryLabel;
    return PopScope(
      canPop: !busy,
      child: Dialog(
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.all(Space.lg),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 14, 12, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: strings.close,
                      icon: Icon(
                        materialIcon(SIcons.close),
                        size: SIconSize.md.pixels,
                      ),
                      onPressed: busy ? null : () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: c.border),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Space.xl),
                  child: body,
                ),
              ),
              if (primaryLabel != null) ...[
                Divider(height: 1, color: c.border),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.xl,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: Space.sm,
                    children: [
                      if (showCancel)
                        TextButton(
                          onPressed: busy ? null : () => Navigator.pop(context),
                          child: Text(strings.cancel),
                        ),
                      FilledButton(
                        onPressed: busy ? null : onPrimary,
                        child: busy
                            ? SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: c.textSubtle,
                                ),
                              )
                            : Text(primaryLabel),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// How wide a confirmation gets on a big phone or a tablet.
const _confirmMaxWidth = 400.0;

class _PhoneConfirm extends StatelessWidget {
  const _PhoneConfirm({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.destructive,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    void confirm() => Navigator.pop(context, true);
    return Dialog(
      insetPadding: const EdgeInsets.all(Space.xl),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _confirmMaxWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.xl,
            Space.xl,
            Space.xl,
            Space.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const Gap(Space.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: text.body, color: c.textMuted),
              ),
              const Gap(Space.xl),
              if (destructive)
                SButtonMaterial.dangerSoft(
                  label: confirmLabel,
                  expand: true,
                  onPressed: confirm,
                )
              else
                SButtonMaterial(
                  label: confirmLabel,
                  expand: true,
                  onPressed: confirm,
                ),
              const Gap(Space.xs),
              Center(
                child: SButtonMaterial.text(
                  label: cancelLabel,
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardConfirm extends StatelessWidget {
  const _DashboardConfirm({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.destructive,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _confirmMaxWidth),
        child: Text(message),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: c.danger,
                  foregroundColor: c.onDanger,
                )
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
