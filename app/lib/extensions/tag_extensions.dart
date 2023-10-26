// Package imports:
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/universal_links_controller.dart';

extension TagExtensions on Tag {
  Uri get feedLink => providerContainer.read(universalLinksControllerProvider.notifier).buildTagRouteLink(key);

  String get toLocale {
    if (topic?.fallback.isNotEmpty == true) {
      return topic!.fallback;
    }

    if (fallback.isNotEmpty == true) {
      return fallback;
    }

    // Change the format of the tag from snake_case to Title Case
    return key.replaceAll('_', ' ').split(' ').map((String word) => word.capitalize()).join(' ');
  }
}
