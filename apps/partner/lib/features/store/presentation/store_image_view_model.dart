import 'package:kernel/kernel.dart';

import '../domain/current_store.dart';
import '../domain/store.dart';
import 'store_view_model.dart';

class StoreImageState {
  const StoreImageState({this.photo, this.progress, this.failed = false});

  /// The new picture, while it uploads or after it failed to.
  final PreparedPhoto? photo;

  /// From 0 to 1 while uploading.
  final double? progress;
  final bool failed;
}

/// Takes or picks the store's logo or cover photo and uploads it right
/// away.
class StoreImageViewModel extends ViewModel<StoreImageState> {
  StoreImageViewModel(this.image);

  final StoreImage image;

  @override
  StoreImageState build() => const StoreImageState();

  /// Returns what the picker said, so the screen can offer the phone's
  /// settings when the camera is off, or say the photo couldn't be used.
  Future<PhotoPick> choose(
    PhotoSource source, {
    required String cropTitle,
  }) async {
    if (state.progress != null) return const PhotoCancelled();
    final pick = await ref
        .read(photoPickerProvider)
        .pick(
          source,
          cropTitle: cropTitle,
          shape: switch (image) {
            StoreImage.logo => PhotoShape.round,
            StoreImage.cover => PhotoShape.wide,
          },
        );
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
    // Finishes even if the owner leaves the page.
    final keepAlive = ref.keepAlive();
    try {
      state = StoreImageState(photo: photo, progress: 0);
      final result = await ref
          .read(storeRepositoryProvider)
          .setImage(
            storeId,
            image,
            photo,
            onProgress: (sent) {
              if (ref.mounted) {
                state = StoreImageState(photo: photo, progress: sent);
              }
            },
          );
      if (!ref.mounted) return;
      switch (result) {
        case Ok(:final value):
          ref.read(storeViewModel.notifier).replace(value);
          state = const StoreImageState();
        case Err():
          state = StoreImageState(photo: photo, failed: true);
      }
    } finally {
      keepAlive.close();
    }
  }
}

final storeImageViewModel = NotifierProvider.autoDispose
    .family<StoreImageViewModel, StoreImageState, StoreImage>(
      StoreImageViewModel.new,
    );
