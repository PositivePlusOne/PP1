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
