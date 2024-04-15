// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/services/third_party.dart';

extension MessageExtensions on Message {
  bool get isEdited {
    return extraData.containsKey('message_text_updated_at');
  }

  static const Set<String> validMessageUriSchemes = {
    'http',
    'https',
    'mailto',
    'tel',
    'sms',
    'geo',
    'mms',
    'smsto',
    'mmsto',
    'pp1',
  };

  Future<void> handleMessageTapped(BuildContext context) async {
    final String? singleUrlFromContent = extractFirstValidUri();
    if (singleUrlFromContent != null) {
      await launchURL(context, singleUrlFromContent);
    }

    final logger = providerContainer.read(loggerProvider);
    logger.w('Unable to action message tap: $this');
  }

  String? extractFirstValidUri() {
    final pattern = RegExp(
      r'(?:(\w+):\/\/)?(?:[a-z0-9\-\.]+)(:[0-9]+)?(\/[^ ]*)?',
      caseSensitive: false,
    );

    final matches = pattern.allMatches(text ?? '');

    for (final match in matches) {
      final scheme = match.group(1);
      if (validMessageUriSchemes.contains(scheme)) {
        return match.group(0);
      }
    }

    return null;
  }
}
