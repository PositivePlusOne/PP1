import 'dart:async';

import 'package:rxdart/rxdart.dart';

class EnhancedBehaviorSubject<T> {
  EnhancedBehaviorSubject({
    required this.subject,
    this.resetDuration = const Duration(seconds: 1),
    this.throttleDuration = const Duration(milliseconds: 500),
  }) {
    Timer.periodic(resetDuration!, (_) {
      subject.add(null);
    });
  }

  final BehaviorSubject<T?> subject;
  final Duration? resetDuration;
  final Duration? throttleDuration;

  DateTime? lastPushedTimestamp;

  void close() {
    subject.close();
  }

  void add(T? value) {
    if (throttleDuration == null) {
      subject.add(value);
      return;
    }

    final DateTime now = DateTime.now();
    if (lastPushedTimestamp != null && now.difference(lastPushedTimestamp!) < throttleDuration!) {
      return;
    }

    subject.add(value);
  }
}
