// Dart imports:
import 'dart:async';

// Package imports:
import 'package:rxdart/rxdart.dart';

class EnhancedBehaviorSubject<T> {
  EnhancedBehaviorSubject({
    required this.subject,
    this.resetDuration = const Duration(seconds: 1),
    this.cancelResetOnAdd = true,
  }) {
    Timer.periodic(resetDuration!, onResetRequested);
  }

  final BehaviorSubject<T?> subject;
  final Duration? resetDuration;

  final bool cancelResetOnAdd;

  DateTime? lastPushedTimestamp;

  void close() {
    subject.close();
  }

  void onResetRequested(Timer timer) {
    if (!cancelResetOnAdd) {
      addIfNotClosed(null);
      return;
    }

    // Check last pushed timestamp is within the reset duration
    if (lastPushedTimestamp == null || DateTime.now().difference(lastPushedTimestamp!) > resetDuration!) {
      addIfNotClosed(null);
    }
  }

  void add(T? value) {
    addIfNotClosed(value);
  }

  void addIfNotClosed(T? value) {
    if (!subject.isClosed) {
      lastPushedTimestamp = DateTime.now();
      subject.add(value);
    }
  }
}
