import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

enum PhotoSource { camera, gallery }

/// A photo ready to upload, square and small, as JPEG files: the full
/// picture and its thumbnail for lists.
@immutable
class PreparedPhoto {
  const PreparedPhoto({
    required this.fullPath,
    required this.thumbPath,
    required this.preview,
  });

  final String fullPath;
  final String thumbPath;

  /// The thumbnail's bytes, to show the photo before it's uploaded.
  final Uint8List preview;
}

/// What came of asking for a photo.
sealed class PhotoPick {
  const PhotoPick();
}

final class PhotoReady extends PhotoPick {
  const PhotoReady(this.photo);

  final PreparedPhoto photo;
}

/// The user backed out of the camera, the gallery or the crop.
final class PhotoCancelled extends PhotoPick {
  const PhotoCancelled();
}

/// The camera (or the photos) is turned off for the app in the phone's
/// settings: [PhotoPicker.openSettings] takes the user there.
final class PhotoAccessDenied extends PhotoPick {
  const PhotoAccessDenied();
}

/// Anything else, e.g. a photo the phone couldn't read.
final class PhotoFailed extends PhotoPick {
  const PhotoFailed(this.error);

  final Object error;
}

/// Takes or picks photos for upload. Tests use a fake.
abstract interface class PhotoPicker {
  /// Takes or picks a photo, lets the user crop it square ([cropTitle] on
  /// top), and makes it small enough to upload on a slow connection.
  Future<PhotoPick> pick(PhotoSource source, {required String cropTitle});

  /// Opens the app's page in the phone's settings, where the camera can be
  /// allowed again.
  Future<void> openSettings();
}

class DevicePhotoPicker implements PhotoPicker {
  const DevicePhotoPicker();

  /// The sides the backend expects: about 200 KB and 30 KB once shrunk.
  static const fullSide = 1280;
  static const thumbSide = 400;

  /// The backend refuses bigger files.
  static const maxBytes = 1024 * 1024;

  @override
  Future<PhotoPick> pick(
    PhotoSource source, {
    required String cropTitle,
  }) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: switch (source) {
          PhotoSource.camera => ImageSource.camera,
          PhotoSource.gallery => ImageSource.gallery,
        },
        requestFullMetadata: false,
      );
      if (picked == null) return const PhotoCancelled();
      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: fullSide,
        maxHeight: fullSide,
        // Kept sharp here: it's shrunk once, below.
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: cropTitle,
            lockAspectRatio: true,
            hideBottomControls: true,
          ),
          IOSUiSettings(
            title: cropTitle,
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );
      if (cropped == null) return const PhotoCancelled();
      final full = await _shrink(cropped.path, side: fullSide, name: 'full');
      final thumb = await _shrink(cropped.path, side: thumbSide, name: 'thumb');
      return PhotoReady(
        PreparedPhoto(
          fullPath: full.path,
          thumbPath: thumb.path,
          preview: await thumb.readAsBytes(),
        ),
      );
    } on PlatformException catch (error) {
      if (error.code == 'camera_access_denied' ||
          error.code == 'photo_access_denied') {
        return const PhotoAccessDenied();
      }
      return PhotoFailed(error);
    } on Exception catch (error) {
      return PhotoFailed(error);
    }
  }

  /// A JPEG [side] pixels wide, under [maxBytes]: the quality drops until
  /// it fits.
  Future<XFile> _shrink(
    String path, {
    required int side,
    required String name,
  }) async {
    final target = '$path-$name.jpg';
    for (final quality in const [80, 65, 50]) {
      final file = await FlutterImageCompress.compressAndGetFile(
        path,
        target,
        minWidth: side,
        minHeight: side,
        quality: quality,
      );
      if (file == null) break;
      if (await file.length() <= maxBytes) return file;
    }
    throw Exception("Couldn't make the photo small enough to upload");
  }

  @override
  Future<void> openSettings() => AppSettings.openAppSettings();
}

final photoPickerProvider = Provider<PhotoPicker>(
  (ref) => const DevicePhotoPicker(),
);
