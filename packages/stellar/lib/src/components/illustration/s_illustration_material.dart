import 'package:flutter/widgets.dart';

import 's_illustration_renderer.dart';

class MaterialIllustrationRenderer implements IllustrationRenderer {
  const MaterialIllustrationRenderer();

  @override
  Widget render(BuildContext context, IllustrationSpec spec) {
    final picture = spec.illustration;
    final arabic = Localizations.localeOf(context).languageCode == 'ar';
    final (file, size) = switch (picture.arabicSize) {
      null => (picture.file, picture.size),
      final arabicSize when arabic => ('${picture.file}_ar', arabicSize),
      _ => ('${picture.file}_en', picture.size),
    };
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size.width),
        child: AspectRatio(
          aspectRatio: size.aspectRatio,
          child: Image.asset(
            'assets/illustrations/$file.png',
            package: picture.package,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ),
      ),
    );
  }
}
