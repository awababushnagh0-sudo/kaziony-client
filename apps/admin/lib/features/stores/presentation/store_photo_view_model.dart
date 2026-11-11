import 'package:kernel/kernel.dart';

import '../domain/store.dart';
import 'store_details_view_model.dart';

class StorePhotoState {
  const StorePhotoState({
    this.photo,
    this.progress,
    this.failed = false,
    this.removing = false,
  });

  /// The new picture, while it uploads or after it failed to.
  final PreparedPhoto? photo;

  /// From 0 to 1 while uploading.
  final double? progress;
  final bool failed;
  final bool removing;

  bool get busy => progress != null || removing;
}

/// A store's logo or cover on its page: picked from the computer and
/// uploaded right away, or removed.
class StorePhotoViewModel extends ViewModel<StorePhotoState> {
  StorePhotoViewModel(this.of);

  /// The store and which of its photos.
  final (String, StoreImage) of;

  StoreDetailsViewModel get _store =>
      ref.read(storeDetailsViewModel(of.$1).notifier);

  @override
  StorePhotoState build() => const StorePhotoState();

  /// Returns what the picker said, so the page can say when the photo
  /// couldn't be used.
  Future<PhotoPick> choose({required String title}) async {
    if (state.busy) return const PhotoCancelled();
    final pick = await ref
        .read(photoPickerProvider)
        .pick(
          PhotoSource.gallery,
          cropTitle: title,
          shape: switch (of.$2) {
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

  /// Null when something else is on its way.
  Future<Result<StoreDetails>?> remove() async {
    if (state.busy) return null;
    state = const StorePhotoState(removing: true);
    final result = await _store.removeImage(of.$2);
    if (ref.mounted) state = const StorePhotoState();
    return result;
  }

  Future<void> _upload(PreparedPhoto photo) async {
    state = StorePhotoState(photo: photo, progress: 0);
    final result = await _store.setImage(
      of.$2,
      photo,
      onProgress: (sent) {
        if (ref.mounted) state = StorePhotoState(photo: photo, progress: sent);
      },
    );
    if (!ref.mounted) return;
    state = result.isOk
        ? const StorePhotoState()
        : StorePhotoState(photo: photo, failed: true);
  }
}

final storePhotoViewModel = NotifierProvider.autoDispose
    .family<StorePhotoViewModel, StorePhotoState, (String, StoreImage)>(
      StorePhotoViewModel.new,
    );
