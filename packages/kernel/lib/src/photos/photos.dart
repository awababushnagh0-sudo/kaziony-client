import 'package:app_settings/app_settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'web_photo_picker.dart';

enum PhotoSource { camera, gallery }

/// A photo ready to upload, small enough for a slow connection: the full
/// picture and its thumbnail for lists.
@immutable
class PreparedPhoto {
  const PreparedPhoto({required this.full, required this.thumb});

  final Uint8List full;
  final Uint8List thumb;

  /// Shows the photo before it's uploaded.
  Uint8List get preview => thumb;

  /// The full picture as an upload's file, for a generated client. A new
  /// one each time: a file can be sent once, and a failed upload is retried.
  MultipartFile fullUpload() => MultipartFile.fromBytes(full, filename: 'full');

  /// The thumbnail as an upload's file, like [fullUpload].
  MultipartFile thumbUpload() =>
      MultipartFile.fromBytes(thumb, filename: 'thumb');
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

/// The photo is too big to upload even once shrunk: a big PNG picked in a
/// browser, which can't make it smaller. A [PhotoFailed.error].
final class PhotoTooLarge implements Exception {
  const PhotoTooLarge();
}

/// How a photo is cropped.
enum PhotoShape {
  /// An item's photo.
  square,

  /// Square, cropped in a circle: a logo.
  round,

  /// 16 by 9: a cover photo across the top of a page.
  wide,
}

/// Takes or picks photos for upload. Tests use a fake.
abstract interface class PhotoPicker {
  /// Takes or picks a photo, lets the user crop it to [shape] ([cropTitle]
  /// on top), and makes it small enough to upload on a slow connection.
  /// In a browser it picks a file and shrinks it, without cropping: the
  /// page shows it cut to [shape] anyway.
  Future<PhotoPick> pick(
    PhotoSource source, {
    required String cropTitle,
    PhotoShape shape = PhotoShape.square,
  });

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
    PhotoShape shape = PhotoShape.square,
  }) async {
    final wide = shape == PhotoShape.wide;
    // A cover keeps the long side; its height follows.
    final fullHeight = wide ? fullSide * 9 ~/ 16 : fullSide;
    final cropStyle = shape == PhotoShape.round
        ? CropStyle.circle
        : CropStyle.rectangle;
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
        aspectRatio: wide
            ? const CropAspectRatio(ratioX: 16, ratioY: 9)
            : const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: fullSide,
        maxHeight: fullHeight,
        // Kept sharp here: it's shrunk once, below.
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: cropTitle,
            cropStyle: cropStyle,
            lockAspectRatio: true,
            hideBottomControls: true,
          ),
          IOSUiSettings(
            title: cropTitle,
            cropStyle: cropStyle,
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );
      if (cropped == null) return const PhotoCancelled();
      final full = await _shrink(
        cropped.path,
        width: fullSide,
        height: fullHeight,
        name: 'full',
      );
      final thumb = await _shrink(
        cropped.path,
        width: thumbSide,
        height: thumbSide * fullHeight ~/ fullSide,
        name: 'thumb',
      );
      return PhotoReady(
        PreparedPhoto(
          full: await full.readAsBytes(),
          thumb: await thumb.readAsBytes(),
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

  /// A JPEG [width] by [height] pixels, under [maxBytes]: the quality drops until
  /// it fits.
  Future<XFile> _shrink(
    String path, {
    required int width,
    required int height,
    required String name,
  }) async {
    final target = '$path-$name.jpg';
    for (final quality in const [80, 65, 50]) {
      final file = await FlutterImageCompress.compressAndGetFile(
        path,
        target,
        minWidth: width,
        minHeight: height,
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
  (ref) => kIsWeb ? const WebPhotoPicker() : const DevicePhotoPicker(),
);
