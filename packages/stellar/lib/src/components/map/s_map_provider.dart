/// Which company draws the maps. Picked per build with `MAP_PROVIDER` in
/// the app's `config/*.json`: `openfreemap` (the default) or `google`.
enum MapProvider {
  /// OpenStreetMap's data drawn by MapLibre, from OpenFreeMap: free, no key
  /// and no account.
  openFreeMap,

  /// Google Maps: needs a key from a Google Cloud project with billing on.
  google;

  /// This build's choice.
  static const configured = String.fromEnvironment('MAP_PROVIDER') == 'google'
      ? google
      : openFreeMap;
}
