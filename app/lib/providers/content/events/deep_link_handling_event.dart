import 'package:app/providers/content/universal_links_controller.dart';

class DeepLinkHandlingEvent {
  const DeepLinkHandlingEvent({
    required this.uri,
    required this.result,
  });

  final Uri? uri;
  final HandleLinkResult result;
}
