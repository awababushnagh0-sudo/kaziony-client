import 'package:flutter/widgets.dart';

import 's_illustration.dart';

/// [SIllustration], drawn from the picture's PNG assets.
class SIllustrationMaterial extends StatelessWidget implements SIllustration {
  const SIllustrationMaterial(this.illustration, {super.key});

  final Illustration illustration;

  @override
  Widget build(BuildContext context) {
    final picture = illustration;
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
