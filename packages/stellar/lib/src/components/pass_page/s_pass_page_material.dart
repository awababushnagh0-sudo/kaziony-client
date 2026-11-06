import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_pass_page.dart';

/// [SPassPage], drawn as a Material [Scaffold] in the brand's green.
class SPassPageMaterial extends StatelessWidget implements SPassPage {
  const SPassPageMaterial({
    required this.title,
    required this.closeTooltip,
    required this.onClose,
    required this.body,
    this.onRefresh,
    this.footerLabel,
    this.onFooter,
    super.key,
  });

  final String title;
  final String closeTooltip;
  final VoidCallback onClose;
  final Widget body;
  final Future<void> Function()? onRefresh;
  final String? footerLabel;
  final VoidCallback? onFooter;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.style.text;
    final footerLabel = this.footerLabel;
    final onRefresh = this.onRefresh;
    Widget content = SingleChildScrollView(
      // Short pages can still be pulled down to reload.
      physics: onRefresh == null ? null : const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        Space.lg,
        Space.sm,
        Space.lg,
        Space.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Space.md,
        children: [
          body,
          if (footerLabel != null && onFooter != null)
            Center(
              child: TextButton(
                onPressed: onFooter,
                style: TextButton.styleFrom(
                  foregroundColor: c.onBrand,
                  minimumSize: const Size(0, 44),
                ),
                // Styled here, not in the button's style: that would
                // replace the theme's font.
                child: Text(
                  footerLabel,
                  style: TextStyle(
                    fontSize: text.small,
                    fontWeight: SFontWeight.semibold.value,
                    decoration: TextDecoration.underline,
                    decorationColor: c.onBrand,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    if (onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: onRefresh,
        color: c.primary,
        backgroundColor: c.surface,
        child: content,
      );
    }
    return Scaffold(
      backgroundColor: c.brandTo,
      appBar: AppBar(
        backgroundColor: c.brandTo,
        foregroundColor: c.onBrand,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        // Light clock and icons on the green.
        systemOverlayStyle: SystemUiOverlayStyle.light,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          tooltip: closeTooltip,
          onPressed: onClose,
          icon: Icon(
            materialIcon(SIcons.close),
            size: SIconSize.md.pixels,
            color: c.onBrand,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: text.subtitle,
            fontWeight: SFontWeight.bold.value,
            color: c.onBrand,
          ),
        ),
      ),
      body: SafeArea(top: false, child: content),
    );
  }
}
