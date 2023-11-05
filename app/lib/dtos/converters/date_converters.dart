// Dart imports:
import 'dart:convert';

String dateFromUnknown(dynamic json) {
  if (json is String) {
    return json;
  }

  if (json is int) {
    return json.toString();
  }

  if (json is Map<String, dynamic>) {
    if (json.containsKey('_seconds') && json.containsKey('_nanoseconds')) {
      final int seconds = json['_seconds'] as int;
      final int nanoseconds = json['_nanoseconds'] as int;
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000 + nanoseconds ~/ 1000000);
      return dateTime.toIso8601String();
    }
  }

  return '';
}

DateTime? dateTimeFromUnknown(dynamic json) {
  if (json is String) {
    return DateTime.parse(json);
  }

  if (json is int) {
    return DateTime.fromMillisecondsSinceEpoch(json);
  }

  if (json is Map<String, dynamic>) {
    if (json.containsKey('_seconds') && json.containsKey('_nanoseconds')) {
      final int seconds = json['_seconds'] as int;
      final int nanoseconds = json['_nanoseconds'] as int;
      return DateTime.fromMillisecondsSinceEpoch(seconds * 1000 + nanoseconds ~/ 1000000);
    }
  }

  return null;
}

String dateToUnknown(String? date) {
  if (date == null || date.isEmpty) {
    return '';
  }

  final DateTime dateTime = DateTime.parse(date);
  final int seconds = dateTime.millisecondsSinceEpoch ~/ 1000;
  final int nanoseconds = dateTime.millisecondsSinceEpoch % 1000 * 1000000;

  return jsonEncode(<String, dynamic>{
    '_seconds': seconds,
    '_nanoseconds': nanoseconds,
  });
}
