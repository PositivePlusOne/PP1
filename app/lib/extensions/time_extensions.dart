// Package imports:
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

extension DateTimeExtensions on DateTime {
  String get timeAgoFromNow {
    final bool isMoreThanOneDayAgo = isBefore(DateTime.now().subtract(const Duration(days: 1)));
    String response = Jiffy.parseFromDateTime(this).fromNow(withPrefixAndSuffix: true);
    if (isMoreThanOneDayAgo) {
      response = Jiffy.parseFromDateTime(this).format(pattern: 'MMM do');
    }

    return response;
  }
}
