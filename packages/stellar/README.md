# stellar

Design system shared by all apps. Apps import `package:stellar/stellar.dart` instead of
`material.dart` or `reactive_forms`.

- **Contracts** (`src/kit/contracts.dart`): a spec + renderer interface per component
- **Kit** (`StellarKit`): one renderer per component; `materialKit` is the default
- **Widgets:** `AppButton`, `AppTextInput`, `AppScaffold`, `AppText`, `AppCard`, `AppListTile`,
  `AppLoadingView`, `AppErrorView`, `AppEmptyView`, `AppAsyncView`, `AppSnack`
- **Forms:** `AppForm`, `FormGroup`, `FormControl`, `Validators`, `AppValidators.libyanPhone`
- **App shell:** `StellarApp` (theme, kit, Arabic/English, right to left)
- **Tokens:** `lightColors`, `Space`, `Radii`, `Gap`

Add a component only when a screen needs it: spec + renderer interface in `contracts.dart`,
Material implementation in `material_kit.dart`, widget in `components.dart`.
