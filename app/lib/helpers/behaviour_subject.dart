// Dart imports:
import 'dart:async';

// Package imports:
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

  DateTime? _lastAdd;

  void add(T? value) {
    if (throttleDuration == null) {
      subject.add(value);
      return;
    }

    final DateTime now = DateTime.now();
    if (_lastAdd != null && now.difference(_lastAdd!) < throttleDuration!) {
      return;
    }

    _lastAdd = now;
    subject.add(value);
  }
}
