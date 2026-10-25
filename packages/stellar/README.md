# stellar

Design system shared by all apps. Apps import `package:stellar/stellar.dart` instead of
`material.dart` or `reactive_forms`.

```
lib/src/
  app/s_app.dart              SApp: theme, kit, Arabic/English, right to left
  foundation/
    s_kit.dart                StellarKit (one renderer per component), StellarScope
    s_tokens.dart             imports every token file below at once
    tokens/
      s_palette.dart          the brand's color values (lightColors, darkColors): rebrand here
      s_colors.dart           StellarColors (the color slots) and SColor (what widgets take)
      s_typography.dart       the font, SFontWeight, TextSizes (text sizes by role)
      s_spacing.dart          Space, Gap
      s_radii.dart            Radii
      s_icon_sizes.dart       SIconSize
      s_image_sizes.dart      SImageSize
      s_style.dart            StellarStyle: the app or dashboard look, with its sizes
  material/
    s_material_kit.dart       materialKit: the Material renderers put together
    s_material_theme.dart     the Material theme built from the tokens
  components/<name>/
    s_<name>.dart             the widget apps use (SButton, ...)
    s_<name>_renderer.dart    its spec and renderer interface (ButtonSpec, ButtonRenderer)
    s_<name>_material.dart    the Material renderer (not exported)
```

| Folder | Widgets |
|---|---|
| `button` | `SButton`, `.secondary`, `.text`, `.menu` ("Actions" dropdown), `.icon` |
| `input` | `STextInput` (`TextInputKind.price` for LD), `SSelectInput`, `SSearchField`, `SCopyField` |
| `form` | `SForm`, `SFieldGrid`, `SFormSection`, `SValidators` (+ `FormGroup`, `FormControl`, `Validators`) |
| `text` | `SText`, `.display`, `.title`, `.caption`: takes `TextVariant`, `SFontWeight`, `SColor` |
| `icon` | `SIcon` (takes `SIconSize`, `SColor`), `SIcons` (the icons apps can use) |
| `scaffold` | `SScaffold` (`parent` for a breadcrumb, `status` for a badge after the title) |
| `shell` | `SShell` (side menu layout for the dashboard) |
| `image` | `SImage` (a photo from the server, cached on the device, with a placeholder) |
| `photo` | `SPhotoField` (a record's photo: add, change, upload progress, retry), `SPhoto.chooseSource`, `SPhoto.askToOpenSettings` |
| `paged_list` | `SPagedList` (phone list: pull to refresh, more rows on scroll) |
| `card`, `list_tile` | `SCard`, `SListTile` (tappable rows get an arrow; `value` at the end), `SListGroup` (rows in a rounded box under a title) |
| `status` | `SLoadingView`, `SEmptyView`, `SErrorView`, `SAsyncView`, `SUpdateRequiredView`, `failureMessage` |
| `snack` | `SSnack.info`, `.success`, `.error` |
| `table` | `STable`, `TableColumn`, `SCellText` |
| `list_page` | `SListPage`, `SFilterBar`, `SPager` |
| `record_page` | `SRecordPage` (tabs + side panel), `RecordTab`, `SRecordProfile`, `SRecordFacts` |
| `settings` | `SSettingsDialog` (page list + pages), `SettingsPage`, `SSettingsGroup`, `SOptionGrid`, `SOptionCard` (a window preview, light/dark) |
| `badge`, `pill` | `SBadge`, `SPill` |
| `dialog` | `SDialog`, `SDialog.show`, `.confirm` |
| `menu` | `SMenuButton`, `MenuEntry` |
| `auth_page` | `SAuthPage` (sign-in pages: title, hint, form) |
| `nav_bar` | `SNavBar`, `NavBarItem` (the phone apps' bottom tabs) |
| `sheet` | `SSheet.choose`, `SheetOption` (bottom sheets) |
| `language` | `SLanguageButton` (globe that opens the language sheet), `chooseLanguage`, `languageName` (for settings rows) |

One folder can hold several kinds of the same thing behind one renderer: `ButtonRenderer`
draws labelled buttons and icon buttons, `InputRenderer` draws text fields, dropdowns,
search boxes and read-only values.

Add a component only when a screen needs it:

1. A folder `components/<name>/` with `s_<name>.dart`, `s_<name>_renderer.dart` and
   `s_<name>_material.dart`.
2. A field for the renderer in `StellarKit` and its Material renderer in `materialKit`.
3. Export the widget and renderer files from `lib/stellar.dart`.

Widgets that only arrange other stellar widgets (`SFieldGrid`, `SFilterBar`) need no
renderer.
