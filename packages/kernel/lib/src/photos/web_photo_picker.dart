import 'package:image_picker/image_picker.dart';

import 'photos.dart';

/// Picks a photo from the computer's files, for the dashboard. The browser
/// can't crop it, so it's only shrunk to the size phones upload; the thumbnail
/// is the photo itself (store photos have none).
class WebPhotoPicker implements PhotoPicker {
  const WebPhotoPicker();

  @override
  Future<PhotoPick> pick(
    PhotoSource source, {
    required String cropTitle,
    PhotoShape shape = PhotoShape.square,
  }) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: DevicePhotoPicker.fullSide.toDouble(),
        maxHeight: DevicePhotoPicker.fullSide.toDouble(),
        // Only JPEG and WebP get smaller with it; a PNG keeps its size.
        imageQuality: 80,
      );
      if (picked == null) return const PhotoCancelled();
      final bytes = await picked.readAsBytes();
      if (bytes.length > DevicePhotoPicker.maxBytes) {
        return const PhotoFailed(PhotoTooLarge());
      }
      return PhotoReady(PreparedPhoto(full: bytes, thumb: bytes));
    } on Exception catch (error) {
      return PhotoFailed(error);
    }
  }

  /// A browser asks for nothing: there's no setting to open.
  @override
  Future<void> openSettings() async {}
}
