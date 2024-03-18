// Package imports:
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:

extension DateTimeExtensions on DateTime {
  String get timeAgoFromNow {
    final bool isMoreThanOneDayAgo = isBefore(DateTime.now().subtract(const Duration(days: 1)));
    String response = Jiffy.parseFromDateTime(this).fromNow(withPrefixAndSuffix: true);
    if (isMoreThanOneDayAgo) {
      response = Jiffy.parseFromDateTime(this).format(pattern: 'MMM do');
    }

    return response;
  }

  // Returns a suitable timestamp for use in chat conversations
  String asMessageTimestamp(Message message) {
    final bool isToday = isAtSameMomentAs(DateTime.now().add(const Duration(days: 1)));
    final bool isYesterday = isAtSameMomentAs(DateTime.now().subtract(const Duration(days: 1)));
    final Jiffy jiffy = Jiffy.parseFromDateTime(this);

    if (isToday) {
      return 'Today at ${jiffy.jm}';
    } else if (isYesterday) {
      return 'Yesterday at ${jiffy.jm}';
    } else {
      return jiffy.yMMMdjm;
    }
  }
}
