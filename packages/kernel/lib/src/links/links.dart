import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens calls, chats, emails and web pages in the phone's own apps. Tests
/// use a fake.
abstract interface class LinkOpener {
  /// False when nothing on the phone could open [link].
  Future<bool> open(Uri link);
}

class DeviceLinkOpener implements LinkOpener {
  const DeviceLinkOpener();

  @override
  Future<bool> open(Uri link) async {
    try {
      return await launchUrl(link, mode: LaunchMode.externalApplication);
    } on PlatformException {
      return false;
    }
  }
}

final linkOpenerProvider = Provider<LinkOpener>(
  (ref) => const DeviceLinkOpener(),
);
