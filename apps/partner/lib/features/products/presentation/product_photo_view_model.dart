import 'package:kernel/kernel.dart';

import '../../store/domain/current_store.dart';
import '../domain/product.dart';
import 'product_view_model.dart';
import 'products_view_model.dart';

class ProductPhotoState {
  const ProductPhotoState({
    this.photo,
    this.progress,
    this.failed = false,
    this.uploaded = false,
  });

  /// The new photo: waiting for a new product to be saved, uploading, or
  /// after it failed to upload.
  final PreparedPhoto? photo;

  /// From 0 to 1 while uploading.
  final double? progress;
  final bool failed;

  /// A new product's photo, sent. It stays shown: the new product has no
  /// loaded page here to show it from.
  final bool uploaded;

  /// Picked but not sent yet, or sent and failed.
  bool get waiting => photo != null && progress == null && !uploaded;
}

/// Takes or picks a product's photo and uploads it right away; for a new
/// product ([productId] null), once the product is saved ([uploadTo]).
class ProductPhotoViewModel extends ViewModel<ProductPhotoState> {
  ProductPhotoViewModel(this.productId);

  final String? productId;

  /// Where the photo goes: the product, or the new one once it's saved.
  String? _target;

  @override
  ProductPhotoState build() {
    _target = productId;
    return const ProductPhotoState();
  }

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
      if (_target == null) {
        state = ProductPhotoState(photo: photo);
      } else {
        await _upload(photo);
      }
    }
    return pick;
  }

  /// Sends the photo picked for a new product, now saved as
  /// [newProductId]. True when there was none to send, or it was sent.
  Future<bool> uploadTo(String newProductId) async {
    _target = newProductId;
    if (state.photo case final photo? when state.waiting) {
      await _upload(photo);
    }
    return !state.failed;
  }

  Future<void> retry() async {
    if (state.photo case final photo? when state.failed && _target != null) {
      await _upload(photo);
    }
  }

  Future<void> openSettings() => ref.read(photoPickerProvider).openSettings();

  Future<void> _upload(PreparedPhoto photo) async {
    final storeId = ref.read(currentStoreProvider)?.storeId;
    final target = _target;
    if (storeId == null || target == null) return;
    // Finishes even if the user leaves the page, so the list gets the
    // photo.
    final keepAlive = ref.keepAlive();
    try {
      state = ProductPhotoState(photo: photo, progress: 0);
      final result = await ref
          .read(productRepositoryProvider)
          .setPhoto(
            storeId,
            target,
            photo,
            onProgress: (sent) {
              if (ref.mounted) {
                state = ProductPhotoState(photo: photo, progress: sent);
              }
            },
          );
      if (!ref.mounted) return;
      switch (result) {
        case Ok() when productId == null:
          ref.invalidate(productsViewModel);
          state = ProductPhotoState(photo: photo, uploaded: true);
        case Ok(:final value):
          ref.read(productViewModel(target).notifier).replace(value);
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
    .family<ProductPhotoViewModel, ProductPhotoState, String?>(
      ProductPhotoViewModel.new,
    );
