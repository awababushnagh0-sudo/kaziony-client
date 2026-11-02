/// Design system shared by all apps: components, theme tokens and forms.
/// Apps import this instead of material.dart or reactive_forms.
///
/// Each component has a folder in `src/components/`: the interface apps use
/// (`s_<name>.dart`, an `abstract interface class` whose factories pick how
/// it's drawn) and the classes that draw it with Material
/// (`s_<name>_material.dart`, not exported).
library;

export 'src/app/s_app.dart';
export 'src/components/alert/s_alert.dart';
export 'src/components/appearance/s_theme_sheet.dart';
export 'src/components/auth_page/s_auth_page.dart';
export 'src/components/badge/s_badge.dart';
export 'src/components/browse/s_browse.dart';
export 'src/components/button/s_button.dart';
export 'src/components/card/s_card.dart';
export 'src/components/code/s_code_card.dart';
export 'src/components/code/s_code_input.dart';
export 'src/components/code/s_qr_code.dart';
export 'src/components/confirmation/s_confirmation_page.dart';
export 'src/components/deal/s_deal_tile.dart';
export 'src/components/dialog/s_dialog.dart';
export 'src/components/form/s_field_grid.dart';
export 'src/components/form/s_form.dart';
export 'src/components/form/s_form_section.dart';
export 'src/components/form/s_validators.dart';
export 'src/components/icon/s_icon.dart';
export 'src/components/illustration/s_illustration.dart';
export 'src/components/image/s_image.dart';
export 'src/components/input/s_choice_input.dart';
export 'src/components/input/s_copy_field.dart';
export 'src/components/input/s_date_time_input.dart';
export 'src/components/input/s_quantity_input.dart';
export 'src/components/input/s_search_field.dart';
export 'src/components/input/s_select_input.dart';
export 'src/components/input/s_text_input.dart';
export 'src/components/item_summary/s_item_summary.dart';
export 'src/components/language/s_language_button.dart';
export 'src/components/language/s_language_sheet.dart';
export 'src/components/list_page/s_filter_bar.dart';
export 'src/components/list_page/s_list_page.dart';
export 'src/components/list_page/s_pager.dart';
export 'src/components/list_tile/s_fact_tile.dart';
export 'src/components/list_tile/s_list_group.dart';
export 'src/components/list_tile/s_list_tile.dart';
export 'src/components/list_tile/s_radio_group.dart';
export 'src/components/list_tile/s_radio_tile.dart';
export 'src/components/map/s_map_page.dart';
export 'src/components/map/s_map_picker.dart';
export 'src/components/map/s_map_provider.dart';
export 'src/components/menu/s_menu_button.dart';
export 'src/components/nav_bar/s_nav_bar.dart';
export 'src/components/paged_list/s_paged_list.dart';
export 'src/components/photo/s_cover_with_logo.dart';
export 'src/components/photo/s_photo.dart';
export 'src/components/photo/s_photo_field.dart';
export 'src/components/pill/s_pill.dart';
export 'src/components/profile/s_profile_header.dart';
export 'src/components/receipt/s_receipt.dart';
export 'src/components/record_page/s_record_facts.dart';
export 'src/components/record_page/s_record_page.dart';
export 'src/components/scaffold/s_scaffold.dart';
export 'src/components/scanner/s_scanner_view.dart';
export 'src/components/section/s_section_header.dart';
export 'src/components/settings/s_option_card.dart';
export 'src/components/settings/s_settings_dialog.dart';
export 'src/components/sheet/s_sheet.dart';
export 'src/components/shell/s_shell.dart';
export 'src/components/sign_in_button/s_sign_in_button.dart';
export 'src/components/snack/s_snack.dart';
export 'src/components/stat/s_figures.dart';
export 'src/components/stat/s_stat_grid.dart';
export 'src/components/stat/s_stat_tile.dart';
export 'src/components/status/s_async_view.dart';
export 'src/components/status/s_empty_view.dart';
export 'src/components/status/s_error_view.dart';
export 'src/components/status/s_loading_view.dart';
export 'src/components/status/s_success_view.dart';
export 'src/components/status/s_update_required_view.dart';
export 'src/components/table/s_table.dart';
export 'src/components/tag/s_tag.dart';
export 'src/components/text/s_link_text.dart';
export 'src/components/text/s_text.dart';
export 'src/components/time_span/s_time_span.dart';
export 'src/components/welcome/s_welcome.dart';
export 'src/foundation/s_scope.dart';
export 'src/foundation/s_tokens.dart';
export 'src/l10n/generated/stellar_localizations.dart';
