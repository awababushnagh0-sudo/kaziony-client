# stellar

Design system shared by all apps. Apps import `package:stellar/stellar.dart` instead of
`material.dart` or `reactive_forms`.

```
lib/src/
  app/s_app.dart              SApp: theme, kit, Arabic/English, right to left
  foundation/
    s_kit.dart                StellarKit (one renderer per component), StellarScope
    s_tokens.dart             colors + SColor, SFontWeight, SIconSize, Space, Radii, density, Gap, font
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
| `input` | `STextInput`, `SSelectInput`, `SSearchField`, `SCopyField`, `SReadField` (a saved value, read-only) |
| `form` | `SForm`, `SFieldGrid`, `SFormSection`, `SValidators` (+ `FormGroup`, `FormControl`, `Validators`) |
| `text` | `SText`, `.display`, `.title`, `.caption`: takes `TextVariant`, `SFontWeight`, `SColor` |
| `icon` | `SIcon` (takes `SIconSize`, `SColor`), `SIcons` (the icons apps can use) |
| `scaffold` | `SScaffold` (`parent` for a breadcrumb, `status` for a badge after the title) |
| `shell` | `SShell` (side menu layout for the dashboard) |
| `card`, `list_tile` | `SCard`, `SListTile` |
| `status` | `SLoadingView`, `SEmptyView`, `SErrorView`, `SAsyncView`, `SUpdateRequiredView`, `failureMessage` |
| `snack` | `SSnack.info`, `.success`, `.error` |
| `table` | `STable`, `TableColumn`, `SCellText` |
| `list_page` | `SListPage`, `SFilterBar`, `SPager` |
| `record_page` | `SRecordPage` (tabs + side panel), `RecordTab`, `SRecordProfile`, `SRecordFacts` |
| `badge`, `pill` | `SBadge`, `SPill` |
| `dialog` | `SDialog`, `SDialog.show`, `.confirm` |
| `menu` | `SMenuButton`, `MenuEntry` |
| `logo` | `SLogo` |

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
