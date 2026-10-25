/// Icon sizes.
enum SIconSize {
  /// Inside small controls: menu items, pills, search boxes.
  xs(16),

  /// Inside fields and pagers.
  sm(18),

  /// The default: buttons, toolbars, list rows.
  md(20),
  lg(24),

  /// Empty and error states.
  xl(48);

  const SIconSize(this.pixels);

  final double pixels;
}
