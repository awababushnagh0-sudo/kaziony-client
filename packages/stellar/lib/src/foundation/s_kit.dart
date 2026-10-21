import 'package:flutter/widgets.dart';

import '../components/badge/s_badge_renderer.dart';
import '../components/button/s_button_renderer.dart';
import '../components/card/s_card_renderer.dart';
import '../components/dialog/s_dialog_renderer.dart';
import '../components/icon/s_icon_renderer.dart';
import '../components/input/s_input_renderer.dart';
import '../components/list_page/s_list_page_renderer.dart';
import '../components/list_tile/s_list_tile_renderer.dart';
import '../components/menu/s_menu_renderer.dart';
import '../components/pill/s_pill_renderer.dart';
import '../components/record_page/s_record_page_renderer.dart';
import '../components/scaffold/s_scaffold_renderer.dart';
import '../components/shell/s_shell_renderer.dart';
import '../components/snack/s_snack_renderer.dart';
import '../components/status/s_status_renderer.dart';
import '../components/table/s_table_renderer.dart';
import '../components/text/s_text_renderer.dart';
import 's_tokens.dart';

/// A complete set of renderers, one per component. Provide another kit to
/// restyle the apps.
@immutable
class StellarKit {
  const StellarKit({
    required this.button,
    required this.input,
    required this.icon,
    required this.text,
    required this.scaffold,
    required this.shell,
    required this.card,
    required this.listTile,
    required this.status,
    required this.snack,
    required this.table,
    required this.listPage,
    required this.recordPage,
    required this.badge,
    required this.pill,
    required this.dialog,
    required this.menu,
  });

  final ButtonRenderer button;
  final InputRenderer input;
  final IconRenderer icon;
  final TextRenderer text;
  final ScaffoldRenderer scaffold;
  final ShellRenderer shell;
  final CardRenderer card;
  final ListTileRenderer listTile;
  final StatusRenderer status;
  final SnackRenderer snack;
  final TableRenderer table;
  final ListPageRenderer listPage;
  final RecordPageRenderer recordPage;
  final BadgeRenderer badge;
  final PillRenderer pill;
  final DialogRenderer dialog;
  final MenuRenderer menu;

  static StellarKit of(BuildContext context) => StellarScope.of(context).kit;
}

/// Provides the active kit and colors to every component below it.
/// Set up by SApp.
class StellarScope extends InheritedWidget {
  const StellarScope({
    required this.kit,
    required this.colors,
    required super.child,
    super.key,
  });

  final StellarKit kit;
  final StellarColors colors;

  static StellarScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StellarScope>();
    assert(scope != null, 'No StellarScope found. Wrap the app in SApp.');
    return scope!;
  }

  @override
  bool updateShouldNotify(StellarScope oldWidget) =>
      kit != oldWidget.kit || colors != oldWidget.colors;
}

extension StellarContext on BuildContext {
  StellarColors get colors => StellarScope.of(this).colors;
}
