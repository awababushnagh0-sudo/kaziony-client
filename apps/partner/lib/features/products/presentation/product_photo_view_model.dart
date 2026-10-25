import 'package:kernel/kernel.dart';

import '../../store/domain/current_store.dart';
import '../domain/product.dart';
import 'product_form_view_model.dart';
import 'products_view_model.dart';

class ProductPhotoState {
  const ProductPhotoState({this.photo, this.progress, this.failed = false});

  /// The new photo while it uploads, and after it failed to.
  final PreparedPhoto? photo;

  /// From 0 to 1 while uploading.
  final double? progress;
  final bool failed;
}

/// Takes or picks a product's photo and uploads it right away.
class ProductPhotoViewModel extends ViewModel<ProductPhotoState> {
  ProductPhotoViewModel(this.productId);

  final String productId;

  @override
  ProductPhotoState build() => const ProductPhotoState();

  /// Returns what the picker said, so the screen can offer the phone's
  /// settings when the camera is off, or say the photo couldn't be used.
  Future<PhotoPick> choose(
    PhotoSource source, {
    required String cropTitle,
  }) async {
    if (state.progress != null) return const PhotoCancelled();
    final pick = await ref
        .read(photoPickerProvider)
        .pick(source, cropTitle: cropTitle);
    if (pick case PhotoReady(:final photo) when ref.mounted) {
      await _upload(photo);
    }
    return pick;
  }

  Future<void> retry() async {
    if (state.photo case final photo? when state.failed) await _upload(photo);
  }

  Future<void> openSettings() => ref.read(photoPickerProvider).openSettings();

  Future<void> _upload(PreparedPhoto photo) async {
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return;
    // Finishes even if the user leaves the page, so the list gets the
    // photo.
    final keepAlive = ref.keepAlive();
    try {
      state = ProductPhotoState(photo: photo, progress: 0);
      final result = await ref
          .read(productRepositoryProvider)
          .setPhoto(
            storeId,
            productId,
            photo,
            onProgress: (sent) {
              if (ref.mounted) {
                state = ProductPhotoState(photo: photo, progress: sent);
              }
            },
          );
      if (!ref.mounted) return;
      switch (result) {
        case Ok(:final value):
          ref.read(productViewModel(productId).notifier).replace(value);
          ref.invalidate(productsViewModel);
          state = const ProductPhotoState();
        case Err():
          state = ProductPhotoState(photo: photo, failed: true);
      }
    } finally {
      keepAlive.close();
    }
  }
}

final productPhotoViewModel = NotifierProvider.autoDispose
    .family<ProductPhotoViewModel, ProductPhotoState, String>(
      ProductPhotoViewModel.new,
    );
