import '../components/badge/s_badge_material.dart';
import '../components/button/s_button_material.dart';
import '../components/card/s_card_material.dart';
import '../components/dialog/s_dialog_material.dart';
import '../components/icon/s_icon_material.dart';
import '../components/image/s_image_material.dart';
import '../components/input/s_input_material.dart';
import '../components/list_page/s_list_page_material.dart';
import '../components/list_tile/s_list_tile_material.dart';
import '../components/menu/s_menu_material.dart';
import '../components/nav_bar/s_nav_bar_material.dart';
import '../components/paged_list/s_paged_list_material.dart';
import '../components/photo/s_photo_material.dart';
import '../components/pill/s_pill_material.dart';
import '../components/record_page/s_record_page_material.dart';
import '../components/scaffold/s_scaffold_material.dart';
import '../components/settings/s_settings_material.dart';
import '../components/sheet/s_sheet_material.dart';
import '../components/shell/s_shell_material.dart';
import '../components/snack/s_snack_material.dart';
import '../components/status/s_status_material.dart';
import '../components/table/s_table_material.dart';
import '../components/text/s_text_material.dart';
import '../foundation/s_kit.dart';

/// The default kit, built on Material widgets. Each renderer lives in its
/// component's folder (`components/<name>/s_<name>_material.dart`).
const materialKit = StellarKit(
  button: MaterialButtonRenderer(),
  input: MaterialInputRenderer(),
  icon: MaterialIconRenderer(),
  image: MaterialImageRenderer(),
  text: MaterialTextRenderer(),
  scaffold: MaterialScaffoldRenderer(),
  shell: MaterialShellRenderer(),
  navBar: MaterialNavBarRenderer(),
  card: MaterialCardRenderer(),
  listTile: MaterialListTileRenderer(),
  pagedList: MaterialPagedListRenderer(),
  photo: MaterialPhotoRenderer(),
  status: MaterialStatusRenderer(),
  snack: MaterialSnackRenderer(),
  table: MaterialTableRenderer(),
  listPage: MaterialListPageRenderer(),
  recordPage: MaterialRecordPageRenderer(),
  badge: MaterialBadgeRenderer(),
  pill: MaterialPillRenderer(),
  dialog: MaterialDialogRenderer(),
  menu: MaterialMenuRenderer(),
  settings: MaterialSettingsRenderer(),
  sheet: MaterialSheetRenderer(),
);
