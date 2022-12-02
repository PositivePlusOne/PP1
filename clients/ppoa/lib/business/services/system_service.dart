import 'package:ppoa/business/services/service_mixin.dart';
import 'package:url_launcher/url_launcher.dart';

class SystemService with ServiceMixin {
  Future<void> handleLinkTap(String text, String? href, String title) async {
    log.fine('Opening link $text - $href - $title');

    final Uri? url = Uri.tryParse(href ?? '');
    if (url == null) {
      log.severe('Cannot parse link $text - $href - $title');
      return;
    }

    try {
      await launchUrl(url);
    } catch (ex) {
      log.severe(ex);
    }
  }
}
