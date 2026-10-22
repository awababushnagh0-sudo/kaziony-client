/// Design system shared by all apps: components, the Material kit, theme
/// tokens and forms. Apps import this instead of material.dart or
/// reactive_forms.
///
/// Each component has a folder in `src/components/`: the widget apps use
/// (`s_<name>.dart`), its spec and renderer interface
/// (`s_<name>_renderer.dart`) and the Material renderer
/// (`s_<name>_material.dart`, not exported).
library;

export 'src/app/s_app.dart';
export 'src/components/badge/s_badge.dart';
export 'src/components/badge/s_badge_renderer.dart';
export 'src/components/button/s_button.dart';
export 'src/components/button/s_button_renderer.dart';
export 'src/components/card/s_card.dart';
export 'src/components/card/s_card_renderer.dart';
export 'src/components/dialog/s_dialog.dart';
export 'src/components/dialog/s_dialog_renderer.dart';
export 'src/components/form/s_field_grid.dart';
export 'src/components/form/s_form.dart';
export 'src/components/form/s_form_section.dart';
export 'src/components/form/s_validators.dart';
export 'src/components/icon/s_icon.dart';
export 'src/components/icon/s_icon_renderer.dart';
export 'src/components/input/s_copy_field.dart';
export 'src/components/input/s_input_renderer.dart';
export 'src/components/input/s_search_field.dart';
export 'src/components/input/s_select_input.dart';
export 'src/components/input/s_text_input.dart';
export 'src/components/list_page/s_filter_bar.dart';
export 'src/components/list_page/s_list_page.dart';
export 'src/components/list_page/s_list_page_renderer.dart';
export 'src/components/list_page/s_pager.dart';
export 'src/components/list_tile/s_list_tile.dart';
export 'src/components/list_tile/s_list_tile_renderer.dart';
export 'src/components/logo/s_logo.dart';
export 'src/components/menu/s_menu_button.dart';
export 'src/components/menu/s_menu_renderer.dart';
export 'src/components/pill/s_pill.dart';
export 'src/components/pill/s_pill_renderer.dart';
export 'src/components/record_page/s_record_facts.dart';
export 'src/components/record_page/s_record_page.dart';
export 'src/components/record_page/s_record_page_renderer.dart';
export 'src/components/scaffold/s_scaffold.dart';
export 'src/components/scaffold/s_scaffold_renderer.dart';
export 'src/components/shell/s_shell.dart';
export 'src/components/shell/s_shell_renderer.dart';
export 'src/components/snack/s_snack.dart';
export 'src/components/snack/s_snack_renderer.dart';
export 'src/components/status/s_async_view.dart';
export 'src/components/status/s_empty_view.dart';
export 'src/components/status/s_error_view.dart';
export 'src/components/status/s_loading_view.dart';
export 'src/components/status/s_status_renderer.dart';
export 'src/components/status/s_update_required_view.dart';
export 'src/components/table/s_table.dart';
export 'src/components/table/s_table_renderer.dart';
export 'src/components/text/s_text.dart';
export 'src/components/text/s_text_renderer.dart';
export 'src/foundation/s_kit.dart';
export 'src/foundation/s_tokens.dart';
export 'src/l10n/generated/stellar_localizations.dart';
export 'src/material/s_material_kit.dart' show materialKit;
