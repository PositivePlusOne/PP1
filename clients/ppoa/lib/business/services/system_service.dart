// Package imports:
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';

class SystemService with ServiceMixin {
  Future<void> handleLinkTap(String text, String? href, String title) async {
    log.v('Opening link $text - $href - $title');

    final Uri? url = Uri.tryParse(href ?? '');
    if (url == null) {
      log.w('Cannot parse link $text - $href - $title');
      return;
    }

    try {
      await launchUrl(url);
    } catch (ex) {
      log.w(ex);
    }
  }
}
