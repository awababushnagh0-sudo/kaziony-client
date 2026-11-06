import 'package:flutter/widgets.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../badge/s_badge_material.dart';
import '../image/s_image_material.dart';
import 's_deal_photo.dart';

/// [SDealPhoto], drawn as an [SImageMaterial] with the tag stacked on it.
class SDealPhotoMaterial extends StatelessWidget implements SDealPhoto {
  const SDealPhotoMaterial(
    this.url, {
    this.size = SImageSize.deal,
    this.discount,
    super.key,
  });

  final String? url;
  final SImageSize size;
  final String? discount;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final discount = this.discount;
    return ClipRRect(
      borderRadius: BorderRadius.circular(size.radius),
      child: Stack(
        children: [
          SImageMaterial(url, size: size),
          if (discount != null)
            PositionedDirectional(
              top: 0,
              start: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: discountGradient(c),
                  borderRadius: const BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(Radii.md),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.sm,
                    vertical: Space.xxs,
                  ),
                  child: Text(
                    discount,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: context.style.text.tiny,
                      fontWeight: SFontWeight.bold.value,
                      height: 1.2,
                      color: c.onDiscount,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
